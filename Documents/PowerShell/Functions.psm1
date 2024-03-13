# ==============================================
# SHELL FUNCTIONS
# ==============================================

function Invoke-Tere() {
    $result = . (Get-Command -CommandType Application tere) $args
    if ($result) {
        Set-Location $result
    }
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

function Get-LatestProfile {
    <#
    .SYNOPSIS
        Checks the Github repository for the latest commit date and compares to the local version.
        If the profile is out of date, instructions are displayed on how to update it.
    #>

    Write-Verbose "Checking for updates to the profile"
    $currentWorkingDirectory = $PWD
    Set-Location $ENV:WindotsLocalRepo
    $gitStatus = git status

    if ($gitStatus -like "*Your branch is up to date with*") {
        Write-Verbose "Profile is up to date"
        Set-Location $currentWorkingDirectory
        return
    }
    else {
        Write-Verbose "Profile is out of date"
        Write-Host "Your PowerShell profile is out of date with the latest commit. To update it, run Update-Profile." -ForegroundColor Yellow
        Set-Location $currentWorkingDirectory
    }
}

function Update-Profile {
    <#
    .SYNOPSIS
        Downloads the latest version of the PowerShell profile from Github, updates the PowerShell profile with the latest version and reruns the setup script.
        Note that functions won't be updated, this requires a full restart. Alias: up
    #>
    Write-Verbose "Storing current working directory in memory"
    $currentWorkingDirectory = $PWD

    Write-Verbose "Updating local profile from Github repository"
    Set-Location $ENV:WindotsLocalRepo
    git pull | Out-Null

    Write-Verbose "Rerunning setup script to capture any new dependencies."
    Start-Process pwsh -Verb runAs -WorkingDirectory $PWD -ArgumentList "-Command .\Setup.ps1"

    Write-Verbose "Reverting to previous working directory"
    Set-Location $currentWorkingDirectory

    Write-Verbose "Re-running profile script from $($PROFILE.CurrentUserAllHosts)"
    .$PROFILE.CurrentUserAllHosts
}

function Update-Software {
    <#
    .SYNOPSIS
        Updates all software installed via Winget & Chocolatey. Alias: us
    #>
    Write-Verbose "Updating software installed via Winget & Chocolatey"
    Start-Process wt -Verb runAs -ArgumentList "pwsh.exe -Command &{winget upgrade --all && choco upgrade all -y}"
    $ENV:UpdatesPending = ''
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

function Get-OrCreateSecret {
    <#
    .SYNOPSIS
        Gets secret from local vault or creates it if it does not exist. Requires SecretManagement and SecretStore modules and a local vault to be created.
        Install Modules with:
            Install-Module Microsoft.PowerShell.SecretManagement, Microsoft.PowerShell.SecretStore
        Create local vault with:
            Install-Module Microsoft.PowerShell.SecretManagement, Microsoft.PowerShell.SecretStore
            Set-SecretStoreConfiguration -Authentication None -Confirm:$False

        https://devblogs.microsoft.com/powershell/secretmanagement-and-secretstore-are-generally-available/

    .PARAMETER secretName
        Name of the secret to get or create. It is recommended to use the username or public key / client id as secret name to make it easier to identify the secret later.

    .EXAMPLE
        $password = Get-OrCreateSecret -secretName $username

    .EXAMPLE
        $clientSecret = Get-OrCreateSecret -secretName $clientId

    .OUTPUTS
        System.String
    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$secretName
    )

    Write-Verbose "Getting secret $secretName"
    $secretValue = Get-Secret $secretName -AsPlainText -ErrorAction SilentlyContinue

    if (!$secretValue) {
        $createSecret = Read-Host "No secret found matching $secretName, create one? Y/N"

        if ($createSecret.ToUpper() -eq "Y") {
            $secretValue = Read-Host -Prompt "Enter secret value for ($secretName)" -AsSecureString
            Set-Secret -Name $secretName -SecureStringSecret $secretValue
            $secretValue = Get-Secret $secretName -AsPlainText
        }
        else {
            throw "Secret not found and not created, exiting"
        }
    }
    return $secretValue
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
