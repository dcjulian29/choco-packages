$packageName = "visualstudio"
$installerType = "EXE"
$installerArgs = "/PASSIVE /NORESTART"
$url = "http://download.microsoft.com/download/6/4/7/647EC5B1-68BE-445E-B137-916A0AE51304/vs_enterprise.exe"
$update = "http://download.microsoft.com/download/c/8/6/c868d99e-f6cb-4b6f-955e-4571614e6fdb/vs2015.2.exe"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

$path32 = 'HKLM:\SOFTWARE\Microsoft\DevDiv\vs\Servicing\14.0'
$path64 = 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\DevDiv\vs\Servicing\14.0'

if (-not ((Test-Path $path32) -or (Test-Path $path64))) {
    Install-ChocolateyPackage $packageName $installerType $installerArgs $url -validExitCodes @(0, 3010)
} else {
    Install-ChocolateyPackage $packageName $installerType $installerArgs $update -validExitCodes @(0, 3010)
}