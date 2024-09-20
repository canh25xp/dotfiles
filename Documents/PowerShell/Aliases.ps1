# ==============================================
# SHELL ALIASES
# ==============================================

# Bash like aliases
Set-Alias -Name su      -Value Start-AdminSession
Set-Alias -Name ff      -Value Find-File
Set-Alias -Name grep    -Value Find-String
Set-Alias -Name df      -Value Get-Volume
Set-Alias -Name which   -Value Show-Command
Set-Alias -Name ls      -Value Get-ChildItemPretty
Set-Alias -Name la      -Value Get-ChildItemPrettyAll
Set-Alias -Name ll      -Value Get-ChildItemPrettyLong
Set-Alias -Name du      -Value Get-DirectorySummary
Set-Alias -Name cat     -Value bat

# Funtion aliases
Set-Alias -Name wifi    -Value Get-Wifi
Set-Alias -Name meme    -Value Show-Meme
Set-Alias -Name wtf     -Value Get-Command
Set-Alias -Name path    -Value Get-Path
Set-Alias -Name env     -Value Edit-EnvironmentVariables
Set-Alias -Name doc     -Value Show-Documents
Set-Alias -Name pro     -Value Open-Profile
Set-Alias -Name word    -Value Open-WinWord
Set-Alias -Name cdi     -Value Open-ListFile
Set-Alias -Name cfg     -Value Edit-Config
Set-Alias -Name cze     -Value Edit-Chezmoi
Set-Alias -Name wm      -Value Start-Komorebi

# Abbreviated aliases
Set-Alias -Name np      -Value notepad
Set-Alias -Name exp     -Value explorer
Set-Alias -Name vi      -Value nvim
Set-Alias -Name vim     -Value nvim
Set-Alias -Name edit    -Value $env:EDITOR
Set-Alias -Name lgit    -Value lazygit
Set-Alias -Name g       -Value git
Set-Alias -Name lg      -Value lazygit
Set-Alias -Name cz      -Value chezmoi
Set-Alias -Name gvim    -Value neovide

Remove-Alias -Name where -Force

# ==============================================
# FUNTIONS
# ==============================================

function Edit-EnvironmentVariables {
  rundll32.exe sysdm.cpl,EditEnvironmentVariables
}

function Set-Wallpaper {
  param (
      [Parameter(Mandatory = $true, Position = 0)]
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
  # Get the list of files managed by chezmoi
  $chezmoiFiles = chezmoi managed -p absolute -i files

  # Use fzf to allow the user to select a file interactively
  $selectedFile = $chezmoiFiles | fzf --preview="bat --color=always {}"
  if ($selectedFile) {
    & $env:EDITOR $selectedFile
  }
}

function Edit-Chezmoi {
  # Get the list of files managed by chezmoi
  $chezmoiFiles = chezmoi managed -p source-absolute -i files

  # Use fzf to allow the user to select a file interactively
  $selectedFile = $chezmoiFiles | fzf --preview="bat --color=always {}"
  if ($selectedFile) {
    & $env:EDITOR $selectedFile
  }
}

function Start-Komorebi {
  $process = Get-Process -Name komorebi -ErrorAction SilentlyContinue

  if (!$process) {
    komorebic start --whkd
  } else {
    Write-Host "komorebi is already running."
  }
}

function Start-AdminSession {
    <#
    .SYNOPSIS
        Starts a new PowerShell session with elevated rights. Alias: su
    #>
    Start-Process -FilePath "wt" -Verb runAs -ArgumentList "pwsh.exe -NoExit -Command &{Set-Location $PWD}"
}

function Open-Telegram {
  & "$env:USERPROFILE\AppData\Roaming\Telegram Desktop\Telegram.exe"
}

function Open-ListFile {
  lf -print-last-dir $args | Set-Location
}

function Open-WinWord(){
    & "C:\Program Files\Microsoft Office\root\Office16\WINWORD.EXE" $args
}

function Get-DirectorySummary($dir=".") {
    Get-ChildItem $dir |
        ForEach-Object { $f = $_ ;
            Get-ChildItem -r $_.FullName |
                Measure-Object -property length -sum |
                    Select-Object @{Name="Name";Expression={$f}},Sum}
}

function Start-GitBash {
    & "$env:PROGRAMFILES\Git\usr\bin\bash.exe" -i -l
}

function Open-Profile{
  Set-Location $HOME\Documents\PowerShell
}

function Get-Path {
    $env:PATH -split ';'
}

function Get-Wifi {
    netsh wlan show profile key=clear $args
}

function Show-Meme {
    <#
    .SYNOPSIS
        Displays meme in the console. Alias: meme
    #>
    param (
        [Parameter(Mandatory = $false, Position = 0)]
        [ValidateSet("nvim", "thisisfine", "man")]
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
    param (
        [Parameter(Mandatory = $false, Position = 0)]
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
    param (
        [Parameter(Mandatory = $true, Position = 0)]
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
    param (
        [Parameter(ValueFromPipeline, Mandatory = $true, Position = 0)]
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
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$SearchTerm,
        [Parameter(ValueFromPipeline, Mandatory = $false, Position = 1)]
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
        Where-Object -FilterScript {$_.Definition -like "$cmdletname"} |
            Format-Table -Property Definition, Name -AutoSize
}

function Show-Documents {
    glow $env:USERPROFILE\Documents\CheatSheets\
}
