# ==============================================
# SHELL FUNCTIONS
# ==============================================

function Open-ListFile {
  param ()
  lf -print-last-dir $args | Set-Location
}

function Open-WinWord(){
	param()
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

function Start-AdminSession {
    <#
    .SYNOPSIS
        Starts a new PowerShell session with elevated rights. Alias: su
    #>
    Start-Process -FilePath "wt" -Verb runAs -ArgumentList "pwsh.exe -NoExit -Command &{Set-Location $PWD}"
}

function Get-Wifi {
    param ()
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
    Invoke-Expression (Get-Content "~\Arts\$Name.ps1" -Raw)
}

function Get-ChildItemPretty {
    <#
    .SYNOPSIS
        Runs eza with a specific set of arguments. Plus some line breaks before and after the output.
        Alias: ls, ll, la, l
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, Position = 0)]
        [string]$Path = $PWD
    )

    Write-Host ""
    eza -a -l --header --icons --hyperlink --time-style relative $Path
    Write-Host ""
}

function Get-ChildItemList {
    <#
    .SYNOPSIS
        ls but list only names
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

function Get-FileFromInternet {
    param(
        [Parameter(Mandatory = $true)]
        [string]
        $URL
    )
    curl -qLO $URL
}
