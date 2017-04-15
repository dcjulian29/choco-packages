$packageName = "bingdesktop"
$installerType = "EXE"
$installerArgs = "/Q"
$url = "http://download.microsoft.com/download/5/0/5/505FFC2C-8E37-41A0-8746-F9F3CF9FD8F9/BingDesktopSetup.exe"

Install-ChocolateyPackage $packageName $installerType $installerArgs $url
