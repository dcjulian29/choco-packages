$packageName = "notepadplusplus" # arbitrary name for the package, used in messages
$installerType = "exe" #only one of these two: exe or msi
$installerArgs = "/S"
$url = "http://download.tuxfamily.org/notepadplus/6.5.4/npp.6.5.4.Installer.exe"

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
