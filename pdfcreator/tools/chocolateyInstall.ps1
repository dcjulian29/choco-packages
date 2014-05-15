$packageName = "pdfcreator"
$installerType = "exe"
$installerArgs = "/L=1033 /SaveINF /SILENT /NORESTART /COMPONENTS=`"program,ghostscript,languages\english`""
$uninstallerArgs = "/SILENT /NORESTART"
$url = "http://white.download.pdfforge.org/pdfcreator/1.7.3/PDFCreator-1_7_3_setup.exe"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
    $ErrorActionPreference = "Stop"
}

try
{
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

    if (Test-Path "$env:ProgramFiles\PDFCreator") {
        $cmd = "$env:ProgramFiles\PDFCreator\PDFCreator.exe"
    }

    if (Test-Path "${env:ProgramFiles(x86)}\PDFCreator") {
        $cmd = "${env:ProgramFiles(x86)}\PDFCreator\PDFCreator.exe"
    }

    if ($cmd -ne $null) {
        cmd /c "`"$cmd`" /NoStart /RemoveWindowsExplorerIntegration"
    }

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
