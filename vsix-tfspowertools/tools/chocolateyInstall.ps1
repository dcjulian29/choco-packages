$packageName = "vsix-tfspowertools"
$installerType = "MSI"
$installerArgs = "/PASSIVE /NORESTART"
$vsgallery = "http://visualstudiogallery.msdn.microsoft.com"
$vsix = "f017b10c-02b4-4d6d-9845-58a06545627f/file/112253/3/Visual%20Studio%20Team%20Foundation%20Server%202013%20Update%202%20Power%20Tools%20.msi"
$url = "$vsgallery/$vsix"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try {
    Install-ChocolateyPackage $packageName $installerType $installerArgs $url

    Write-ChocolateySuccess $packageName
} catch {
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
