$packageName = "pdfcreaftor"
$installerType = "exe"
$installerArgs = "/SILENT /NORESTART"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try
{
    if (Test-Path "$env:ProgramFiles\PDFCreator") {
        $cmd = "$env:ProgramFiles\PDFCreator\unins000.exe"
    }

    if (Test-Path "${env:ProgramFiles(x86)}\PDFCreator") {
        $cmd = "${env:ProgramFiles(x86)}\PDFCreator\unins000.exe"
    }

    Uninstall-ChocolateyPackage $packageName $installerType $installerArgs $cmd

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
