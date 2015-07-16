$packageName = "xmind"
$installerType = "EXE"
$installerArgs = "/SILENT"
$url = "http://dl2.xmind.net/xmind-downloads/xmind-windows-3.5.3.201506180105.exe"

Install-ChocolateyPackage $packageName $installerType $installerArgs $url

if (Test-Path "$($env:USERPROFILE)\Desktop\XMind 6.lnk") {
    Remove-Item "$($env:USERPROFILE)\Desktop\XMind 6.lnk" -force
}
