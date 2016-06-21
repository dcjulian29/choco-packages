$packageName = "winmerge"
$installerType = "EXE"
$installerArgs = "/VERYSILENT /SP- /NORESTART"
$url = "http://downloads.sourceforge.net/winmerge/WinMerge-2.14.0-Setup.exe"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

Install-ChocolateyPackage $packageName $installerType $installerArgs $url $url

if ("$env:SYSTEMDRIVE\etc\SoftwareDevelopment.flt") {
    Copy-Item "$env:SYSTEMDRIVE\etc\SoftwareDevelopment.flt" "$env:PF32\WinMerge\Filters\" -Force
}
