$packageName = "xmind"
$installerType = "EXE"
$installerArgs = "/SILENT"
$url = "http://dl3.xmind.net/xmind-7-update1-windows.exe"

Install-ChocolateyPackage $packageName $installerType $installerArgs $url

if (Test-Path "$($env:USERPROFILE)\Desktop\XMind 7.lnk") {
    Remove-Item "$($env:USERPROFILE)\Desktop\XMind 7.lnk" -force
}
