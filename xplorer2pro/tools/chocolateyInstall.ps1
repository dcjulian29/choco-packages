$packageName = "xplorer2pro"
$installerType = "exe"
$installerArgs = "/S"
$url = 'http://zabkat.com/xplorer2_setup.exe'
$url64 = 'http://zabkat.com/xplorer2_setup64.exe'

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
