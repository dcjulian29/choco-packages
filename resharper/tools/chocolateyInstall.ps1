$packageName = "resharper"
$installerType = "EXE"
$installerArgs = "/VsVersion=14 /SpecificProductNames=ReSharper;dotCover;teamCityAddin;dotPeek /Silent=True"
$url = "https://download.jetbrains.com/resharper/JetBrains.ReSharperUltimate.2016.3.2.exe"
$downloadPath = "$env:TEMP\$packageName"

if (Test-Path $downloadPath) {
    Remove-Item -Path $downloadPath -Recurse -Force
}

New-Item -Type Directory -Path $downloadPath | Out-Null

Download-File $url "$downloadPath\$packageName.$installerType"

Invoke-ElevatedCommand "$downloadPath\$packageName.$installerType" -ArgumentList $installerArgs -Wait
