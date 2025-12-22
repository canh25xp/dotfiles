function Get-HelpAI {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Prompt
    )

    $defaultSystemPrompt = @"
You are a command-line assistant.

Primary goals:
- Provide correct, minimal, copy-pasteable CLI commands.
- Prefer POSIX-compatible shell unless specified.
- Assume Linux by default. Unless user specified Windows.
- No emojis. No roleplay. No motivational text.

Rules:
- Output ONE single command only.
- When multiple solutions exist, show the best default only.
- NO explanations.
- NO extra text.
- NO multiple options.
- NO OS comparisons.
- NO warnings.
- NO punctuation outside the command.

Output format:

```sh
command
```
"@.Trim()

    $systemPromptPath = Join-Path $HOME ".ollama/models/mistral-cli-helper"
    $systemPrompt = $null

    if (Test-Path $systemPromptPath) {
        try {
            $systemPromptConfig = Get-Content -Raw -Path $systemPromptPath
            $systemPromptMatch = [regex]::Match(
                $systemPromptConfig,
                'SYSTEM\s+"""\s*([\s\S]*?)\s*"""',
                'Singleline'
            )

            if ($systemPromptMatch.Success) {
                $systemPrompt = $systemPromptMatch.Groups[1].Value.Trim()
            }
        } catch {
            Write-Verbose "Failed to read system prompt from $systemPromptPath : $($_.Exception.Message)"
        }
    }

    if (-not $systemPrompt) {
        $systemPrompt = $defaultSystemPrompt
    }

    $ollamaHost = if ($env:OLLAMA_HOST) {
        $env:OLLAMA_HOST.TrimEnd('/')
    } else {
        "http://127.0.0.1:11434"
    }
    $requestUri = "$ollamaHost/api/chat"

    $payload = @{
        model = "mistral"
        stream = $false
        messages = @(
            @{ role = "system"; content = $systemPrompt }
            @{ role = "user"; content = $Prompt }
        )
    }

    if (-not (Get-Command curl.exe -ErrorAction SilentlyContinue)) {
        Write-Warning "curl.exe not found in PATH."
        return $null
    }

    try {
        $jsonPayload = $payload | ConvertTo-Json -Depth 6 -Compress
    } catch {
        Write-Warning "Failed to serialize payload to JSON: $($_.Exception.Message)"
        return $null
    }

    $curlArgs = @(
        "-s"
        "-S"
        "--fail"
        "-X"
        "POST"
        $requestUri
        "-H"
        "Content-Type: application/json"
        "--data"
        $jsonPayload
    )

    try {
        $responseRaw = & curl.exe @curlArgs
    } catch {
        Write-Warning "Failed to invoke curl.exe for $requestUri : $($_.Exception.Message)"
        return $null
    }

    if ([string]::IsNullOrWhiteSpace($responseRaw)) {
        Write-Warning "No response from Ollama API for prompt: '$Prompt'."
        return $null
    }

    try {
        $response = $responseRaw | ConvertFrom-Json -Depth 6
    } catch {
        Write-Warning "Failed to parse Ollama response as JSON. Returning raw output."
        return $responseRaw.Trim()
    }

    $output = $null

    if ($response -and $response.message -and $response.message.content) {
        $output = $response.message.content
    } elseif ($response -and $response.messages) {
        $output = ($response.messages | Select-Object -Last 1).content
    }

    if (-not $output) {
        Write-Warning "No response from ollama for prompt: '$Prompt'."
        return $null
    }

    # This regex captures everything inside the first ```...``` block.
    $match = [regex]::Match(
        $output,
        '```[a-zA-Z0-9_-]*\s*([\s\S]*?)\s*```',
        'Singleline'
    )

    if ($match.Success) {
        return $match.Groups[1].Value.Trim()
    }

    Write-Warning "No code block found in response. Returning raw output."
    return $output.Trim()
}

function Select-TerminalBackground {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false, Position=0)]
        [string]$Path
    )

    $wallpaperDir = Join-Path $HOME "Pictures/Wallpapers"
    $configPath = Join-Path $HOME ".config/chezmoi/chezmoi.yaml"
    $terminalSettingsPath = "$HOME/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json"

    if ($PSBoundParameters.ContainsKey('Path')) {
        if (-not (Test-Path $Path)) {
            Write-Error "The provided path does not exist: $Path"
            return
        }

        $fullPath = Resolve-Path $Path | Select-Object -ExpandProperty Path
        $selection = Resolve-Path $Path | Get-Item | Select-Object -ExpandProperty Name
        Write-Debug "Directly selected: $fullPath"
    }
    else {
        $wallpaperDir = Join-Path $HOME "Pictures/Wallpapers"
        $configPath = Join-Path $HOME ".config/chezmoi/chezmoi.yaml"
        $terminalSettingsPath = "$HOME/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json"

        if (-not (Test-Path $wallpaperDir)) {
            Write-Error "Wallpaper directory not found at $wallpaperDir"
            return
        }
        if (-not (Get-Command fzf -ErrorAction SilentlyContinue)) {
            Write-Error "fzf command is required but not found."
            return
        }

        Push-Location $wallpaperDir
        try {
            $selection = Get-ChildItem -File |
                Select-Object -ExpandProperty Name |
                fzf --cycle `
                    --prompt="Select Wallpaper > " `
                    --preview-window="right:60%" `
                    --preview "chafa --format=sixel --animate=off {}"
        } finally {
            Pop-Location
        }

        if ([string]::IsNullOrWhiteSpace($selection)) {
            Write-Warning "No image selected. Operation cancelled."
            return
        }

        $fullPath = Join-Path $wallpaperDir $selection
        Write-Debug "Selected: $fullPath"
    }

    if (-not (Test-Path -Path $configPath)) {
        Write-Error "chezmoi config not found at $configPath"
        return
    }

    $content = Get-Content -Raw -Path $configPath

    # Prepare path for YAML (Escape backslashes: C:\Path becomes C:\\Path)
    $yamlReadyPath = $fullPath -replace "\\", "\\"

    # Regex to find 'wallpaper: "..."'
    # We use non-greedy matching (.*?) to ensure we only capture inside the quotes
    $pattern = 'wallpaper:\s*".*?"'

    if ($content -match $pattern) {
        $replacement = "wallpaper: ""$yamlReadyPath"""
        $newContent = [regex]::Replace($content, $pattern, $replacement)
        Set-Content -Path $configPath -Value $newContent -Encoding UTF8
        Write-Debug "Updated chezmoi.yaml configuration."
    } else {
        Write-Error "Unable to find 'wallpaper' key in $configPath. Check your formatting."
        return
    }

    try {
        Write-Debug "Applying changes to Windows Terminal..."
        & chezmoi apply $terminalSettingsPath 2>&1
        if ($LASTEXITCODE -ne 0) {
            Write-Warning "chezmoi apply exited with code $LASTEXITCODE"
        } else {
            Write-Output "Set wallpaper: $selection"
        }
    } catch {
        Write-Warning "Failed to run chezmoi apply: $_"
    }
}

function Switch-TerminalBackground {
    # Toggle chezmoi terminal background flag to switch focus mode
    $configPath = Join-Path $HOME ".config/chezmoi/chezmoi.yaml"

    if (-not (Test-Path -Path $configPath)) {
        Write-Error "chezmoi config not found at $configPath"
        return
    }

    $content = Get-Content -Raw -Path $configPath

    if ($content -match "terminalBackground:\s*true") {
        $newContent = [regex]::Replace($content,"terminalBackground:\s*true","terminalBackground: false",1)
        $newValue = $false
    } elseif ($content -match "terminalBackground:\s*false") {
        $newContent = [regex]::Replace($content,"terminalBackground:\s*false","terminalBackground: true",1)
        $newValue = $true
    } else {
        Write-Error "Unable to find terminalBackground setting in $configPath"
        return
    }

    Set-Content -Path $configPath -Value $newContent -Encoding UTF8
    try {
        & chezmoi apply "$HOME/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json" 2>&1
        if ($LASTEXITCODE -ne 0) {
            Write-Warning "chezmoi apply exited with code $LASTEXITCODE"
        }
    } catch {
        Write-Warning "Failed to run chezmoi apply: $_"
    }

    if (-not $newValue) {
        $imagePath = Join-Path $HOME "Pictures/Wallpapers/YouHaveToLockIn.jpg"
        $message = "You have to lock in"
        $chafa = Get-Command chafa -ErrorAction SilentlyContinue

        Write-Output $message
        if (-not (Test-Path -Path $imagePath)) {
            Write-Warning "Image not found at $imagePath"
        } elseif ($null -ne $chafa) {
            try {
                & $chafa $imagePath
            } catch {
                Write-Warning "Failed to render image with chafa: $_"
            }
        }
    }

    Write-Output "terminalBackground set to $newValue"
}

function Edit-P4File {
    param(
        [string]$path,
        [string]$outdir = "$env:TEMP/p4"
    )

    $relativePath = $path -replace '^//',''
    $outPath = Join-Path -Path $outdir -ChildPath $relativePath
    $directory = Split-Path -Path $outPath -Parent

    if (-not (Test-Path $directory)) {
        New-Item -Path $directory -ItemType Directory -Force | Out-Null
    }

    & p4 print -o $outPath $path
    nvim $outPath
}

function Copy-HFSLink {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path,

        # TODO: remove hardcoded link
        [string]$HfsRoot = "C:\Archive",
        [string]$HfsServer = "http://107.98.39.128:6969"
    )

    # Normalize input path
    $fullPath = (Resolve-Path $Path).ProviderPath

    if ($fullPath -notlike "$HfsRoot*") {
        Write-Error "The path must be inside the HFS root ($HfsRoot)."
        return
    }

    # Get relative path
    $relativePath = $fullPath.Substring($HfsRoot.Length).TrimStart('\')

    # Convert Windows backslashes to forward slashes
    $urlPath = $relativePath -replace '\\','/'

    # Build the final URL
    $link = "$HfsServer/$urlPath"

    # Copy to clipboard
    Set-Clipboard -Value $link

    Write-Output "Copied to clipboard: $link"
}

function Get-ClipboardFiles {
    Add-Type -AssemblyName System.Windows.Forms
    [Windows.Forms.Clipboard]::GetFileDropList() | ForEach-Object { Copy-Item $_ . }
}

function Open-Anything {
    param(
        [Parameter(Mandatory)]
        [string]$id,

        [switch]$plm,
        [switch]$soc,
        [switch]$cl,
        [switch]$qb
    )

    $url = $null

    if ($plm) {
        $url = "https://splm.sec.samsung.net/wl/tqm/defect/defectreg/getDefectCodeSearch.do?defectCode=$id"
    } elseif ($soc) {
        $url = "https://b2b.samsungsemi.com/b2b/lsi/quality/wiznet/wiznetEditIssueK2.do?issueId=$id"
    } elseif ($qb) {
        $url = "https://android.qb.sec.samsung.net/build/$id"
    } elseif ($cl) {
        $url = "https://review1716.sec.samsung.net/changes/$id"
    }

    switch -regex ($id) {
        '^P\d{6}-\d{5}$' {
            $url = "https://splm.sec.samsung.net/wl/tqm/defect/defectreg/getDefectCodeSearch.do?defectCode=$id"
            break
        }
        '^SOC-\d{6}$' {
            $url = "https://b2b.samsungsemi.com/b2b/lsi/quality/wiznet/wiznetEditIssueK2.do?issueId=$id"
            break
        }
        '^\d{8,}$' {
            $url = "https://android.qb.sec.samsung.net/build/$id"
            break
        }
    }

    if ($url) {
        Write-Output "Opening: $url"
        Start-Process $url
    } else {
        Write-Warning "Cannot deduce type from ID: $id. Please specify -plm, -soc, -cl, or -qb."
    }
}

function Get-WslPath {
    param(
        [string]$DistributionName
    )

    $registryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Lxss"
    $dist = Get-ChildItem -Path $registryPath | Where-Object { $_.GetValue("DistributionName") -eq $DistributionName }

    if ($dist) {
        return $dist.GetValue("BasePath") + "\ext4.vhdx"
    } else {
        Write-Error "Distribution '$DistributionName' not found."
    }
}

function Save-ClipboardImage {
    param(
        [string]$OutputPath = "out.png"
    )
    nircmd clipboard saveimage $OutputPath
    Write-Host "Clipboard image saved to $OutputPath"
}

function Open-History () {
    Get-Content (Get-PSReadLineOption).HistorySavePath | less
}

function Set-LocationInteractive {
    $tmp = [System.IO.Path]::GetTempFileName()
    yazi $args --cwd-file="$tmp"
    $cwd = Get-Content -Path $tmp
    if (-not [string]::IsNullOrEmpty($cwd) -and $cwd -ne $PWD.Path) {
        Set-Location -LiteralPath $cwd
    }
    Remove-Item -Path $tmp
}

function Search-BrowerHistory () {
    $Columns = [int]((Get-Host).ui.rawui.WindowSize.Width / 3)
    $Separator = '{::}'
    $History = "$env:USERPROFILE\AppData\Local\Google\Chrome\User Data\Default\History"
    $TempFile = New-TemporaryFile
    $Query = "select substr(title, 1, $Columns), url from urls order by last_visit_time desc"
    Copy-Item $History -Destination $TempFile
    @(sqlite3 -Separator "$Separator" "$TempFile" "$Query") |
        ForEach-Object {
            $Title,$Url = ($_ -split $Separator)[0,1]
            "$($Title.PadRight($Columns))  `e[36m$Url`e[0m"
        } | fzf --ansi --multi | ForEach-Object { Start-Process "chrome.exe" ($_ -replace '.*(https*://)','$1'),'--profile-directory="Default"' }
}

#BUG: jq: error: syntax error, unexpected INVALID_CHARACTER, expecting end of file (Windows cmd shell quoting issues?) at <top-level>, line 1
function Search-BrowerBookmarks () {
    $Bookmarks = "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Bookmarks"

    $JqScript = @"
     def ancestors: while(. | length >= 2; del(.[-1,-2]));
     . as `$in | paths(.url?) as `$key | `$in | getpath(`$key) | {name,url, path: [`$key[0:-2] | ancestors as `$a | `$in | getpath(`$a) | .name?] | reverse | join(\`"/\`") } | .path + \`"/\`" + .name + \`"|\`" + .url
"@
    Get-Content "$Bookmarks" | jq -r "$JqScript" `
    | ForEach-Object {
        $_ -replace "(.*)\|(.*)","`$1`t`e[36m`$2`e[0m"
    } `
    | fzf --ansi `
    | ForEach-Object {
        Start-Process "chrome.exe" ($_ -split "`t")[1],'--profile-directory="Default"'
    }
}

function Search-Command {
    $cmd = Get-Content ~/.commands | fzf --prompt="Select command: "
    if ($cmd) {
        Invoke-Expression $cmd
    }
}

function Open-Uninstall {
    appwiz.cpl
}

function Open-RecycleBin {
    Start-Process shell:RecycleBinFolder
}

function Edit-EnvironmentVariables {
    rundll32.exe sysdm.cpl,EditEnvironmentVariables
}

function Set-Wallpaper {
    param(
        [Parameter(Mandatory = $true,Position = 0)]
        [string]$path
    )
    $setwallpapersrc = @"
    using System.Runtime.InteropServices;

    public class Wallpaper {
        public const int SetDesktopWallpaper = 20;
        public const int UpdateIniFile = 0x01;
        public const int SendWinIniChange = 0x02;
        [DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
        private static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
        public static void SetWallpaper(string path) {
            SystemParametersInfo(SetDesktopWallpaper, 0, path, UpdateIniFile | SendWinIniChange);
        }
    }
"@

    Add-Type -TypeDefinition $setwallpapersrc

    [Wallpaper]::SetWallpaper($path)
}

function Edit-Config {
    param(
        [Parameter(Mandatory = $false,Position = 0)]
        [string]$query = ""
    )
    # Get the list of files managed by chezmoi
    $chezmoiFiles = chezmoi managed -p absolute -i files

    # Use fzf to allow the user to select a file interactively
    $selectedFile = $chezmoiFiles | fzf --preview "bat --color=always {}"
    if ($selectedFile) {
        & $env:EDITOR $selectedFile
    }
}

function Edit-Chezmoi {
    # Get the list of files managed by chezmoi
    $chezmoiFiles = chezmoi managed -p absolute -i files

    # Use fzf to allow the user to select a file interactively
    $selectedFile = $chezmoiFiles | fzf --preview "bat --color=always {}"
    if ($selectedFile) {
        & chezmoi edit --apply --watch $selectedFile
    }
}

function Open-Telegram {
    & "$env:USERPROFILE\AppData\Roaming\Telegram Desktop\Telegram.exe"
}

function Open-WinWord () {
    & "C:\Program Files\Microsoft Office\root\Office16\WINWORD.EXE" $args
}

function Get-DirectorySummary ($dir = ".") {
    Get-ChildItem $dir |
        ForEach-Object { $f = $_;
            Get-ChildItem -r $_.FullName |
                Measure-Object -Property length -Sum |
                Select-Object @{ Name = "Name"; Expression = { $f } },Sum }
}

function Start-GitBash {
    & "$env:PROGRAMFILES\Git\usr\bin\bash.exe" -i -l
}

function Open-Profile {
    Set-Location $HOME\Documents\PowerShell
}

function Get-Path {
    $env:PATH -split ';'
}

function Get-SystemPath {
    [Environment]::GetEnvironmentVariable("PATH",[System.EnvironmentVariableTarget]::Machine).Split(";")
}

function Get-UserPath {
    [Environment]::GetEnvironmentVariable("PATH",[System.EnvironmentVariableTarget]::User).Split(";")
}

function Get-Wifi {
    netsh wlan show profile key=clear $args
}

function Show-Meme {
    <#
    .SYNOPSIS
        Displays meme in the console. Alias: meme
    #>
    param(
        [Parameter(Mandatory = $false,Position = 0)]
        [ValidateSet("nvim","thisisfine","man")]
        [string]$Name = "thisisfine"
    )
    Invoke-Expression (Get-Content "~\Pictures\Arts\$Name.ps1" -Raw)
}

function Get-ChildItemList {
    <#
    .SYNOPSIS
        ls with fancy icons
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false,Position = 0)]
        [string]$Path = $PWD
    )
    Get-ChildItem $Path | Format-TerminalIcons
}

function Show-Command {
    <#
    .SYNOPSIS
        Displays the definition of a command. Alias: which
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true,Position = 0)]
        [string]$Name
    )
    Write-Verbose "Showing definition of '$Name'"
    Get-Command $Name | Select-Object -ExpandProperty Definition
}

function Find-File {
    <#
    .SYNOPSIS
        Finds a file in the current directory and all subdirectories. Alias: ff
    #>
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline,Mandatory = $true,Position = 0)]
        [string]$SearchTerm
    )

    Write-Verbose "Searching for '$SearchTerm' in current directory and subdirectories"
    $result = Get-ChildItem -Recurse -Filter "*$SearchTerm*" -ErrorAction SilentlyContinue

    Write-Verbose "Outputting results to table"
    $result | Format-Table -AutoSize
}


function Find-String {
    <#
    .SYNOPSIS
        Searches for a string in a file or directory. Alias: grep
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true,Position = 0)]
        [string]$SearchTerm,
        [Parameter(ValueFromPipeline,Mandatory = $false,Position = 1)]
        [string]$Directory,
        [Parameter(Mandatory = $false)]
        [switch]$Recurse
    )

    Write-Verbose "Searching for '$SearchTerm' in '$Directory'"
    if ($Directory) {
        if ($Recurse) {
            Write-Verbose "Searching for '$SearchTerm' in '$Directory' and subdirectories"
            Get-ChildItem -Recurse $Directory | Select-String $SearchTerm
            return
        }

        Write-Verbose "Searching for '$SearchTerm' in '$Directory'"
        Get-ChildItem $Directory | Select-String $SearchTerm
        return
    }

    if ($Recurse) {
        Write-Verbose "Searching for '$SearchTerm' in current directory and subdirectories"
        Get-ChildItem -Recurse | Select-String $SearchTerm
        return
    }

    Write-Verbose "Searching for '$SearchTerm' in current directory"
    Get-ChildItem | Select-String $SearchTerm
}

function Get-CmdletAlias ($cmdletname) {
    Get-Alias |
        Where-Object -FilterScript { $_.Definition -like "$cmdletname" } |
        Format-Table -Property Definition,Name -AutoSize
}

function Show-Documents {
    glow $env:USERPROFILE\Documents\CheatSheets\
}

#https://www.powershellgallery.com/packages/PoshFunctions/2.2.11/Content/Functions%5CMove-ToRecycleBin.ps1
function Move-ToRecycleBin {
    <#
.SYNOPSIS
    Instead of outright deleting a file, why not move it to the Recycle Bin?
.DESCRIPTION
    Instead of outright deleting a file, why not move it to the Recycle Bin?
    Function aliased to 'Recycle'
.PARAMETER Path
    A string or array of strings representing a file or a folder. Wildcards are
    acceptable and will be resolved to specific file or folder names. Can accept
    values from the pipeline.
.EXAMPLE
    Move-ToRecycleBin -Path c:\temp\dummyfile.txt -Verbose
 
    VERBOSE: Moving 'c:\temp\dummyfile.txt' to the Recycle Bin
.EXAMPLE
    Move-ToRecycleBin -Path c:\temp\dummyfile2.txt
 
    Would move c:\temp\dummyfile2.txt to the Recycle Bin
.EXAMPLE
    Move-ToRecycleBin .\FileDoesNotExist
 
    Move-ToRecycleBin : ERROR: Path [.\FileDoesNotExist] does not exist
.EXAMPLE
    Move-ToRecycleBin -Path 'File1.txt', 'File2.txt'
 
    Would move both File1.txt and File2.txt to the Recycle Bin
#>

    [CmdletBinding(ConfirmImpact = 'Medium')]
    [Alias('Recycle')]
    param(
        [Parameter(Mandatory,HelpMessage = 'Please enter a path to a file or folder. Wildcards accepted.',ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [string[]]$Path
    )

    begin {
        Add-Type -AssemblyName Microsoft.VisualBasic
        $FileSystem = New-Object -TypeName 'Microsoft.VisualBasic.FileIO.FileSystem'
        Write-Verbose -Message "Starting [$($MyInvocation.MyCommand)]"
    }

    process {
        foreach ($currentPath in $Path) {
            if (Test-Path -Path $currentPath) {
                $File = Resolve-Path -Path $currentPath
                foreach ($currentFile in $File) {
                    Write-Verbose -Message ("Moving '{0}' to the Recycle Bin" -f $currentFile)
                    if (Test-Path -Path $currentFile -PathType Container) {
                        $FileSystem::DeleteDirectory($currentFile,'OnlyErrorDialogs','SendToRecycleBin')
                    } else {
                        $FileSystem::DeleteFile($currentFile,'OnlyErrorDialogs','SendToRecycleBin')
                    }
                }
            } else {
                Write-Error -Message "ERROR: Path [$currentPath] does not exist"
            }
        }
    }

    end {
        Remove-Variable -Name FileSystem
        Write-Verbose -Message "Ending [$($MyInvocation.MyCommand)]"
    }
}

function Start-AdminSession {
    $shell = if ($PSVersionTable.PSEdition -eq 'Core') {
        'pwsh.exe'
    } else {
        'powershell.exe' # 'Desktop'
    }

    Start-Process -FilePath 'wt' -Verb RunAs -ArgumentList "$shell -NoExit -Command `"Set-Location '$PWD'`""
}
