$packageName = "virtualbox" # arbitrary name for the package, used in messages
$installerType = "exe" #only one of these two: exe or msi
$installerArgs = "--silent"
$url = "http://download.virtualbox.org/virtualbox/4.3.4/VirtualBox-4.3.4-91027-Win.exe"
$url64 = $url # 64bit URL here or just use the same as $url

try
{
    Install-ChocolateyPackage $packageName $installerType $installerArgs $url $url64

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
