$packageName = "mysettings-devwallpaper"
$wallpaper = "$($env:PUBLIC)\Pictures\wallpaper.png"

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

    [Win32Api]::SystemParametersInfo(20, 0, "", 3);

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
