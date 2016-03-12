$packageName = "pdfcreator"
$installerType = "exe"
$installerArgs = "/L=1033 /SaveINF /SILENT /NORESTART /COMPONENTS=`"program,ghostscript,languages\english`""
$uninstallerArgs = "/SILENT /NORESTART"
$url = "http://orange.download.pdfforge.org/pdfcreator/2.3.0/PDFCreator-2_3_0-Setup.exe"
$toolDir = "$(Split-Path -parent $MyInvocation.MyCommand.Path)"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

# Uninstall PDFCreator if older version is installed
if (Test-Path "$env:ProgramFiles\PDFCreator") {
    $uninstall = "$env:ProgramFiles\PDFCreator\unins000.exe"
}

if (Test-Path "${env:ProgramFiles(x86)}\PDFCreator") {
    $uninstall = "${env:ProgramFiles(x86)}\PDFCreator\unins000.exe"
}

if ($uninstall -ne $null) {
    Uninstall-ChocolateyPackage $packageName $installerType $uninstallerArgs $uninstall
}

Install-ChocolateyPackage $packageName $installerType $installerArgs $url

if (Test-ProcessAdminRights) {
    . $toolDir\postInstall.ps1
} else {
    Start-ChocolateyProcessAsAdmin ". $toolDir\postInstall.ps1"
}

Write-ChocolateySuccess $packageName
