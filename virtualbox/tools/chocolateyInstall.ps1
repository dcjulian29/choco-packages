$packageName = "virtualbox"
$installerType = "EXE"
$installerArgs = "--silent"
$url = "http://download.virtualbox.org/virtualbox/4.3.8/VirtualBox-4.3.8-92456-Win.exe"

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
