$packageName = "mysqlworkbench"
$installerType = "MSI"
$installerArgs = "/passive /norestart"
$url = "http://cdn.mysql.com/Downloads/MySQLGUITools/mysql-workbench-community-6.3.6-win32.msi"
$vcredist = "https://download.microsoft.com/download/2/E/6/2E61CFA4-993B-4DD4-91DA-3737CD5CD6E3/vcredist_x86.exe"
$vcredist64 = "https://download.microsoft.com/download/2/E/6/2E61CFA4-993B-4DD4-91DA-3737CD5CD6E3/vcredist_x64.exe"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

if ((Get-WmiObject Win32_Processor).AddressWidth -eq 64) {
    if (-not (Test-Path "HKLM:SOFTWARE\WOW6432Node\Microsoft\DevDiv\vc\Servicing\12.0")) {
        Install-ChocolateyPackage "vcredist2013" "EXE" "/install /passive /norestart" $vcredist
    }

    if (-not (Test-Path "HKLM:SOFTWARE\Microsoft\DevDiv\vc\Servicing\12.0")) {
        Install-ChocolateyPackage "vcredist2013" "EXE" "/install /passive /norestart" "" $vcredist64
    }
} else {
    if (-not (Test-Path "HKLM:SOFTWARE\Microsoft\DevDiv\vc\Servicing\12.0")) {
        Install-ChocolateyPackage "vcredist2013" "EXE" "/install /passive /norestart" $vcredist
    }
}

Install-ChocolateyPackage $packageName $installerType $installerArgs $url
