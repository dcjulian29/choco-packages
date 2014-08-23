$packageName = "xplorer2"
$installerType = "exe"
$installerArgs = "/S"
$url = 'http://zabkat.com/xplorer2_setup.exe'
$url64 = 'http://zabkat.com/xplorer2_setup64.exe'

try
{
    Install-ChocolateyPackage $packageName $installerType $installerArgs $url $url64

    Start-ChocolateyProcessAsAdmin "Remove-Item '$($env:PUBLIC)\Desktop\xplorer2 pro x64.lnk' -Force"

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
