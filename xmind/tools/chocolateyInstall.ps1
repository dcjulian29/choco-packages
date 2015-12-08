$packageName = "xmind"
$installerType = "EXE"
$installerArgs = "/SILENT"
$url = "http://www.xmind.net/xmind/downloads/xmind7-windows-3.6.0.R-201511090408.exe"

Install-ChocolateyPackage $packageName $installerType $installerArgs $url

if (Test-Path "$($env:USERPROFILE)\Desktop\XMind 7.lnk") {
    Remove-Item "$($env:USERPROFILE)\Desktop\XMind 7.lnk" -force
}
