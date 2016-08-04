$packageName = "winmerge"
$installerType = "EXE"
$installerArgs = "/VERYSILENT /SP- /NORESTART"
$url = "https://julianscorner.com/downloads/WinMerge-2.14.0-Setup.exe"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

Install-ChocolateyPackage $packageName $installerType $installerArgs $url $url

if (Test-Path "$env:SYSTEMDRIVE\etc\SoftwareDevelopment.flt") {
    Copy-Item "$env:SYSTEMDRIVE\etc\SoftwareDevelopment.flt" "$env:PF32\WinMerge\Filters\" -Force
}
