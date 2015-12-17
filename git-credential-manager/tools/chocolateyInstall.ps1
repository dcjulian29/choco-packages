$packageName = "git-credential-manager"
$url = "https://github.com/Microsoft/Git-Credential-Manager-for-Windows/releases/download/v1.0.0/Setup.exe"
$installerType = 'exe'
$silentArgs = '/SILENT /NORESTART'
 
Install-ChocolateyPackage $packageName $installerType $silentArgs $url
