$packageName = "notepadplusplus" # arbitrary name for the package, used in messages
$installerType = "exe" #only one of these two: exe or msi
$installerArgs = "/S"
$url = "http://download.tuxfamily.org/notepadplus/6.5.2/npp.6.5.2.Installer.exe"
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
