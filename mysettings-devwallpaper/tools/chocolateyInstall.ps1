$url = "https://julianscorner.com/dl/codebackground.jpg"
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

if (Test-Path $wallpaper) {
    Remove-Item -Path $wallpaper -Force
}

(New-Object System.Net.WebClient).DownloadFile($url, $wallpaper)

Set-ItemProperty -Path "HKCU:Control Panel\Desktop" -Name "WallPaperStyle" -Value "2"
Set-ItemProperty -Path "HKCU:Control Panel\Desktop" -Name "TileWallPaper" -Value "0"

[Win32Api]::SystemParametersInfo(20, 0, $wallpaper, 3);
