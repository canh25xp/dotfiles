# https://gist.github.com/s7ephen/714023
# https://forums.powershell.org/t/powershell-to-set-second-monitor-wallpaper/17949
# Note: if scheduling this script, you may need to check 
# that the powershell session is logged in as the user

Write-Host "================================================================================"
Write-Host "[Chezmoi] Set Wallpaper"

$path = if ($args.Count -eq 0) {
  "$HOME\Pictures\Wallpapers\YorForger.jpg"
} else {
  $args[0]
}

$confirmation = Read-Host "Do you want to set the wallpaper to '$path'? (Y/n)"

if ($confirmation -eq 'n') {
    Write-Host "Wallpaper change cancelled."
    exit
}

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
