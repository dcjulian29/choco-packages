$packageName = "dotnetcore"
$installerType = 'exe'
$installerArgs = '/passive'
$url = 'https://download.microsoft.com/download/1/4/1/141760B3-805B-4583-B17C-8C5BC5A876AB/Installers/dotnet-dev-win-x86.1.0.0-preview2-1-003177.exe'
$url64 = 'https://download.microsoft.com/download/1/4/1/141760B3-805B-4583-B17C-8C5BC5A876AB/Installers/dotnet-dev-win-x64.1.0.0-preview2-1-003177.exe'
$downloadPath = "$env:TEMP\$packageName\"

if ([System.IntPtr]::Size -ne 4) {
    $url = $url64
}

if (Test-Path $downloadPath) {
    Remove-Item -Path $downloadPath -Recurse -Force
}

New-Item -Type Directory -Path $downloadPath | Out-Null

Download-File $url "$downloadPath\$packageName.$installerType"

Invoke-ElevatedCommand "$downloadPath\$packageName.$installerType" -ArgumentList $installerArgs -Wait
