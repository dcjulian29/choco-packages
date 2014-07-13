$packageName = "sumatrapdf"
$installerType = "exe"
$installerArgs = "/s /register /opt plugin,pdffilter,pdfpreviewer "
$url = "https://kjkpub.s3.amazonaws.com/sumatrapdf/rel/SumatraPDF-2.5.1-install.exe"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try
{
    Install-ChocolateyPackage $packageName $installerType $installerArgs $url

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
