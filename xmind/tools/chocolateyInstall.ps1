$packageName = "xmind" # arbitrary name for the package, used in messages
$installerType = "exe" #only one of these two: exe or msi
$installerArgs = "/SILENT"
$url = "http://www.xmind.net/xmind/downloads/xmind-windows-3.4.0.201311050558.exe"
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
