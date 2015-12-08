$packageName = "visualstudio"
$installerType = "EXE"
$installerArgs = "/PASSIVE /NORESTART"
$url = "http://download.microsoft.com/download/6/4/7/647EC5B1-68BE-445E-B137-916A0AE51304/vs_enterprise.exe"
$update = "http://download.microsoft.com/download/4/C/1/4C113E0D-8590-47AB-B7B8-E41E0AD7936D/VS2015.1.exe"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

$path32 = 'HKLM:\SOFTWARE\Microsoft\DevDiv\vs\Servicing\14.0'
$path64 = 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\DevDiv\vs\Servicing\14.0'

if (-not ((Test-Path $path32) -or (Test-Path $path64))) {
    Install-ChocolateyPackage $packageName $installerType $installerArgs $url -validExitCodes @(0, 3010)
}

Install-ChocolateyPackage $packageName $installerType $installerArgs $update -validExitCodes @(0, 3010)
