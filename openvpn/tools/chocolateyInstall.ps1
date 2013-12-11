$packageName = "openvpn" # arbitrary name for the package, used in messages
$installerType = "exe" #only one of these two: exe or msi
$installerArgs = "/S"
$url = "http://swupdate.openvpn.org/community/releases/openvpn-install-2.3.2-I003-i686.exe"
$url64 = "http://swupdate.openvpn.org/community/releases/openvpn-install-2.3.2-I003-x86_64.exe"

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
