$packageName = "anydvd"
$installerType = "exe"
$installerArgs = "/S"
$url = "http://static.slysoft.com/SetupAnyDVD7540.exe"

try
{
    Install-ChocolateyPackage $packageName $installerType $installerArgs $url $url

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
