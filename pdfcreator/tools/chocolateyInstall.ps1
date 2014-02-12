$packageName = "pdfcreator"
$installerType = "exe"
$installerArgs = "/L=1033 /SaveINF /SILENT /NORESTART /COMPONENTS=`"program,ghostscript,languages\english`""
$uninstallerArgs = "/SILENT /NORESTART"
$url = "http://download.pdfforge.org/download/pdfcreator/PDFCreator-stable?download"

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
        $uninstall = "$env:ProgramFiles\PDFCreator\unins000.exe"
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

    cmd /c "`"$cmd`" /NoStart /RemoveWindowsExplorerIntegration"

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
