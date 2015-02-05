$packageName = "php"
$version = "5.6.5"
$url = "http://windows.php.net/downloads/releases/php-$version-nts-Win32-VC11-x86.zip"
$url64 = "http://windows.php.net/downloads/releases/php-$version-nts-Win32-VC11-x64.zip" 
$installArgs = "/install /passive /norestart"
$vcredist = "http://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU_4/vcredist_x86.exe"
$vcredist64 = "http://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU_4/vcredist_x64.exe"

$downloadPath = "$env:TEMP\chocolatey\$packageName"
$appDir = "$($env:SYSTEMDRIVE)\tools\apps\$($packageName)"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try
{
    if (Test-Path $appDir) {
      Remove-Item "$($appDir)" -Recurse -Force
    }

    New-Item -Type Directory -Path $appDir | Out-Null

    if (-not (Test-Path $downloadPath)) {
        New-Item -Type Directory -Path $downloadPath | Out-Null
    }

    
    if (-not (Test-Path "HKLM:SOFTWARE\Microsoft\DevDiv\vc\Servicing\11.0")) {
        Install-ChocolateyPackage "vcredist2012" "EXE" $installerArgs $vcredist $vcredist64
    }
    
    Get-ChocolateyWebFile $packageName "$downloadPath\$packageName.zip" $url $url64
    Get-ChocolateyUnzip "$downloadPath\$packageName.zip" "$appDir\"

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
