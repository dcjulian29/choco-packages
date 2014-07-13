$packageName = "mysettings-devwallpaper"
$url = "http://37.media.tumblr.com/tumblr_m8337kd2eG1qbkusho1_1280.png"
$wallpaper = "$($env:PUBLIC)\Pictures\wallpaper.png"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

Add-Type @"
using System;
using System.Runtime.InteropServices;
using Microsoft.Win32;
public class Win32Api {
    [DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
    public static extern int SystemParametersInfo (int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@

try
{
    if (Test-Path $wallpaper) {
        Remove-Item -Path $wallpaper -Force
    }
    
    Get-ChocolateyWebFile $packageName $wallpaper $url
    
    Set-ItemProperty -Path "HKCU:Control Panel\Desktop" -Name "WallPaperStyle" -Value "2"
    Set-ItemProperty -Path "HKCU:Control Panel\Desktop" -Name "TileWallPaper" -Value "0"

    [Win32Api]::SystemParametersInfo(20, 0, $wallpaper, 3);

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
