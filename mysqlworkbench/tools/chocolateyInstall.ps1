$packageName = "mysqlworkbench"
$installerType = "MSI"
$installerArgs = "/passive /norestart"
$url = "http://cdn.mysql.com/Downloads/MySQLGUITools/mysql-workbench-community-6.3.6-win32.msi"
$vcredist = "https://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU_4/vcredist_x86.exe"
$vcredist64 = "https://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU_4/vcredist_x64.exe"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

if ((Get-WmiObject Win32_Processor).AddressWidth -eq 64) {
    if (-not (Test-Path "HKLM:SOFTWARE\WOW6432Node\Microsoft\DevDiv\vc\Servicing\11.0")) {
        Install-ChocolateyPackage "vcredist2012" "EXE" "/install /passive /norestart" $vcredist
    }

    if (-not (Test-Path "HKLM:SOFTWARE\Microsoft\DevDiv\vc\Servicing\11.0")) {
        Install-ChocolateyPackage "vcredist2012" "EXE" "/install /passive /norestart" "" $vcredist64
    }
} else {
    if (-not (Test-Path "HKLM:SOFTWARE\Microsoft\DevDiv\vc\Servicing\11.0")) {
        Install-ChocolateyPackage "vcredist2012" "EXE" "/install /passive /norestart" $vcredist
    }
}

Install-ChocolateyPackage $packageName $installerType $installerArgs $url
