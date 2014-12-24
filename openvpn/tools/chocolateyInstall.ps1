$packageName = "openvpn" # arbitrary name for the package, used in messages
$installerType = "exe" #only one of these two: exe or msi
$installerArgs = "/S"
$url = "http://swupdate.openvpn.org/community/releases/openvpn-install-2.3.6-I601-i686.exe"
$url64 = "http://swupdate.openvpn.org/community/releases/openvpn-install-2.3.6-I601-x86_64.exe"

try
{
    Install-ChocolateyPackage $packageName $installerType $installerArgs $url $url64

    if (Test-ProcessAdminRights) {
        Remove-Item "$($env:PUBLIC)\Desktop\OpenVPN GUI.lnk" -Force
    } else {
        Start-ChocolateyProcessAsAdmin "Remove-Item '$($env:PUBLIC)\Desktop\OpenVPN GUI.lnk' -Force"
    }

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
