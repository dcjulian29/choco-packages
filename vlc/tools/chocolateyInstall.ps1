$packageName = "vlc" # arbitrary name for the package, used in messages
$installerType = "exe" #only one of these two: exe or msi
$installerArgs = "/L=1033 /S"
$url = "http://get.videolan.org/vlc/2.1.2/win32/vlc-2.1.2-win32.exe"
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
