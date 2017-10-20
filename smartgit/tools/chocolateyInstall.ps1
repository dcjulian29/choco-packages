$packageName = "smartgit"
$downloadPath = "$env:LOCALAPPDATA\Temp\$packageName"
$installerArgs = '/sp- /silent /norestart'
$version = '17_1_0'

$url = `
    'https://www.syntevo.com/static/smart/download/smartgit/smartgit-win32-setup-jre-{0}.zip' `
    -f $version

if (Test-Path $downloadPath) {
    Remove-Item -Path $downloadPath -Recurse -Force | Out-Null
}

New-Item -Type Directory -Path $downloadPath | Out-Null

Download-File $url "$downloadPath\$packageName.zip"
Unzip-File "$downloadPath\$packageName.zip" "$downloadPath\"

$installFileLocation = [IO.Path]::Combine($downloadPath, "setup-{0}-jre.exe" -f $version)

Invoke-ElevatedCommand $installFileLocation -ArgumentList $installerArgs -Wait

$java = Find-JavaPath

Invoke-ElevatedExpression  `
    "[Environment]::SetEnvironmentVariable('SMARTGIT_JAVA_HOME','$java', 'Machine')"
