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

# Winmerge also downloads VC 2008 Redistributable
# but puts the installers in whatever directory the filesystem is in...
# This is a know bug. https://support.microsoft.com/en-us/kb/950683
# So we will remove them manually.
$vc2008Files = @(
"install.exe",
"install.res.1028.dll",
"install.res.1031.dll",
"install.res.1033.dll",
"install.res.1036.dll",
"install.res.1040.dll",
"install.res.1041.dll",
"install.res.1042.dll",
"install.res.2052.dll",
"install.res.3082.dll",
"vcredist.bmp",
"globdata.ini",
"install.ini",
"eula.1028.txt", 
"eula.1031.txt",
"eula.1033.txt",
"eula.1036.txt",
"eula.1040.txt",
"eula.1041.txt",
"eula.1042.txt",
"eula.2052.txt",
"eula.3082.txt",
"VC_RED.MSI",
"VC_RED.cab"
)

$vc2008Files | ForEach { Remove-Item $(Join-Path $env:SYSTEMDRIVE $_) -Force }
