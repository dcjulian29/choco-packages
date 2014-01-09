$packageName = "anydvd"
$installerType = "exe"
$installerArgs = "/S"
$url = "http://static.slysoft.com/SetupAnyDVD7400.exe"
$url64 = $url

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
