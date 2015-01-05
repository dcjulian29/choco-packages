$packageName = "notepadplusplus"
$installerType = "EXE"
$installerArgs = "/S"
$url = "http://download.tuxfamily.org/notepadplus/6.7.3/npp.6.7.3.Installer.exe"

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
