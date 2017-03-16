$packageName = "php"
$version = "7.1.2"
$installArgs = "/install /passive /norestart"

$url = "http://windows.php.net/downloads/releases/php-$version-nts-Win32-VC14-x86.zip"
if ([System.IntPtr]::Size -ne 4) {
    $url = "http://windows.php.net/downloads/releases/php-$version-nts-Win32-VC14-x64.zip" 
}


$vcredist = "https://download.microsoft.com/download/9/3/F/93FCF1E7-E6A4-478B-96E7-D4B285925B00/vc_redist.x86.exe"
$vcredist64 = "https://download.microsoft.com/download/9/3/F/93FCF1E7-E6A4-478B-96E7-D4B285925B00/vc_redist.x64.exe"

$downloadPath = "$env:TEMP\$packageName"
$appDir = "$($env:SYSTEMDRIVE)\tools\apps\$($packageName)"

if (Test-Path $downloadPath) {
    Remove-Item $downloadPath -Recurse -Force | Out-Null
}

New-Item -Type Directory -Path $downloadPath | Out-Null

if ((Get-WmiObject Win32_Processor).AddressWidth -eq 64) {
    if (-not (Test-Path "HKLM:SOFTWARE\WOW6432Node\Microsoft\DevDiv\vc\Servicing\14.0")) {
        Download-File $url "$downloadPath\vcredist.exe"
        Invoke-ElevatedCommand "$downloadPath\vcredist.exe" -ArgumentList $installArgs -Wait
    }
    
    if (-not (Test-Path "HKLM:SOFTWARE\Microsoft\DevDiv\vc\Servicing\14.0")) {
    Download-File $url "$downloadPath\vcredist64.exe"
        Invoke-ElevatedCommand "$downloadPath\vcredist64.exe" -ArgumentList $installArgs -Wait
    }
} else {
    if (-not (Test-Path "HKLM:SOFTWARE\Microsoft\DevDiv\vc\Servicing\14.0")) {
        Download-File $url "$downloadPath\vcredist.exe"
        Invoke-ElevatedCommand "$downloadPath\vcredist.exe" -ArgumentList $installArgs -Wait
    }
}

Download-File $url "$downloadPath\$packageName.zip"

if (Test-Path $appDir) {
  Remove-Item "$($appDir)" -Recurse -Force
}

New-Item -Type Directory -Path $appDir | Out-Null

Unzip-File "$downloadPath\$packageName.zip" "$appDir\"

Copy-Item "$appDir\php.ini-production" "$appDir\php.ini"
