# Download the latest distro.tar release from https://github.com/mvaisakh/wsl-distro-tars

$repo = "mvaisakh/wsl-distro-tars"
$apiUrl = "https://api.github.com/repos/$repo/releases/latest"

$response = Invoke-RestMethod -Uri $apiUrl -Headers @{ "User-Agent" = "PowerShell" }

$asset = $response.assets | Where-Object { $_.name -match "^debian\.unstable-.*\.tar$" } | Select-Object -First 1

if ($null -ne $asset) {
    $url = $asset.browser_download_url
    $fileName = $asset.name

    Write-Host "Downloading $url..."
    Invoke-WebRequest -Uri $url -OutFile $fileName
    Write-Host "Downloaded to: $fileName"
} else {
    Write-Warning "No matching debian.unstable-*.tar asset found in the latest release."
}
