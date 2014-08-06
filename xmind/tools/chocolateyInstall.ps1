$packageName = "xmind"
$installerType = "EXE"
$installerArgs = "/SILENT"
$url = "http://www.xmind.net/xmind/downloads/xmind-windows-3.4.1.201401221918.exe"

try
{
    Install-ChocolateyPackage $packageName $installerType $installerArgs $url

    Remove-Item "$($env:USERPROFILE)\Desktop\XMind 2013.lnk" -force

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
