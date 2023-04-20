$version = "${env:ChocolateyPackageVersion}"
$url = "https://github.com/dcjulian29/ansible-dev/releases/download/$version/ansible-dev_Windows_x86_64.zip"
$app = "${env:ChocolateyInstall}\bin\ansible-dev.exe"

if (Test-Path $app) {
    Write-Output "Removing previous version of application..."
    Remove-Item -Path $app -Force
}

Remove-Item -Path "${env:TEMP}\ansible-dev.zip" -Force -ErrorAction SilentlyContinue
Invoke-WebRequest -Uri $url -OutFile "${env:TEMP}\ansible-dev.zip" -UseBasicParsing
Expand-Archive -Path "${env:TEMP}\ansible-dev.zip" -Destination $env:TEMP -Force
Move-Item -Path "$env:TEMP\ansible-dev.exe" -Destination $app
Remove-Item -Path "${env:TEMP}\ansible-dev.zip" -Force
Remove-Item -Path "${env:TEMP}\LICENSE" -Force
Remove-Item -Path "${env:TEMP}\README.md" -Force
