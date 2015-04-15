$packageName = "pdfcreator"
$installerType = "exe"
$installerArgs = "/L=1033 /SaveINF /SILENT /NORESTART /COMPONENTS=`"program,ghostscript,languages\english`""
$uninstallerArgs = "/SILENT /NORESTART"
$url = "http://olive.download.pdfforge.org/pdfcreator/2.1.1/PDFCreator-2_1_1-setup.exe"
$toolDir = "$(Split-Path -parent $MyInvocation.MyCommand.Path)"


if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try {
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
} catch {
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
