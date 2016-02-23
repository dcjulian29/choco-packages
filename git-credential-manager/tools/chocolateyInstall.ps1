$packageName = "git-credential-manager"
$url = "https://github.com/Microsoft/Git-Credential-Manager-for-Windows/releases/download/v1.1.0/GCMW-1.1.0.exe"
$installerType = 'exe'
$silentArgs = '/SILENT /NORESTART'
 
Install-ChocolateyPackage $packageName $installerType $silentArgs $url
