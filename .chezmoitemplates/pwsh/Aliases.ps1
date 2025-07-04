
# Unix-like aliases
Set-Alias -Name df -Value Get-Volume
Set-Alias -Name du -Value Get-DirectorySummary
Set-Alias -Name ff -Value Find-File
Set-Alias -Name grep -Value Find-String
Set-Alias -Name la -Value Get-ChildItemPrettyAll
Set-Alias -Name ll -Value Get-ChildItemPrettyLong
Set-Alias -Name ls -Value Get-ChildItemPretty
Set-Alias -Name su -Value Start-AdminSession
Set-Alias -Name which -Value Show-Command
Set-Alias -Name whichwsl -Value Get-WslPath

# Funtion aliases
Set-Alias -Name bhis -Value Search-BrowerHistory
Set-Alias -Name bmark -Value Search-BrowerBookmarks
Set-Alias -Name cdi -Value Set-LocationInteractive
Set-Alias -Name cfg -Value Edit-Config
Set-Alias -Name cze -Value Edit-Chezmoi
Set-Alias -Name doc -Value Show-Documents
Set-Alias -Name env -Value Edit-EnvironmentVariables
Set-Alias -Name his -Value Open-History
Set-Alias -Name huh -Value Search-Command
Set-Alias -Name meme -Value Show-Meme
Set-Alias -Name omni -Value Open-Anything
Set-Alias -Name path -Value Get-Path
Set-Alias -Name pro -Value Open-Profile
Set-Alias -Name sci -Value Save-ClipboardImage
Set-Alias -Name syspath -Value Get-SystemPath
Set-Alias -Name trash -Value Open-RecycleBin
Set-Alias -Name unins -Value Open-Uninstall
Set-Alias -Name userpath -Value Get-UserPath
Set-Alias -Name wifi -Value Get-Wifi
Set-Alias -Name wm -Value Start-Komorebi
Set-Alias -Name word -Value Open-WinWord
Set-Alias -Name wtf -Value Get-Command
Set-Alias -Name yeet -Value Move-ToRecycleBin
Set-Alias -Name nuke -Value Clear-RecycleBin

# Abbreviated aliases
Set-Alias -Name cz -Value chezmoi
Set-Alias -Name edit -Value $env:EDITOR
Set-Alias -Name exp -Value explorer
Set-Alias -Name gvim -Value neovide
Set-Alias -Name g -Value git
Set-Alias -Name lg -Value lazygit
Set-Alias -Name lgit -Value lazygit
Set-Alias -Name y -Value yazi

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

#function Set-LocationInteractive {
#  $tmp = [System.IO.Path]::GetTempFileName()
#  yazi $args --cwd-file="$tmp"
#  $cwd = Get-Content -Path $tmp
#  if (-not [string]::IsNullOrEmpty($cwd) -and $cwd -ne $PWD.Path) {
#    Set-Location -LiteralPath $cwd
#  }
#  Remove-Item -Path $tmp
#}

function Set-LocationInteractive {
  lf -print-last-dir $args | Set-Location
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

function Start-Komorebi {
  $process = Get-Process -Name komorebi -ErrorAction SilentlyContinue

  if (!$process) {
    komorebic start --whkd --bar
  } else {
    Write-Host "komorebi is already running."
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

function Get-ChildItemPretty {
  eza --icons -1 --hyperlink --time-style relative $args
}

function Get-ChildItemPrettyAll {
  eza -a --icons -1 --hyperlink --time-style relative $args
}

function Get-ChildItemPrettyLong {
  eza -a -l --icons --hyperlink --time-style relative $args
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
