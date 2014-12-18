$packageName = "xmind"
$installerType = "EXE"
$installerArgs = "/SILENT"
$url = "http://dl2.xmind.net/xmind-downloads/xmind-windows-3.5.1.201411201906.exe"

try
{
    Install-ChocolateyPackage $packageName $installerType $installerArgs $url

    Remove-Item "$($env:USERPROFILE)\Desktop\XMind 6.lnk" -force

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
