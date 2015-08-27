$packageName = "dotpeek"
$url = "http://download.jetbrains.com/resharper/dotPeek32_1.5.exe"
$url64 = "http://download.jetbrains.com/resharper/dotPeek64_1.5.exe"
$downloadPath = "$env:TEMP\chocolatey\$packageName"
$appDir = "$($env:SYSTEMDRIVE)\tools\apps\$($packageName)"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

if (Test-Path $appDir) {
    Write-Output "Removing previous version of package..."
    Remove-Item "$($appDir)" -Recurse -Force
}

New-Item -Type Directory -Path $appDir | Out-Null

if (-not (Test-Path $downloadPath)) {
    New-Item -Type Directory -Path $downloadPath | Out-Null
}

Get-ChocolateyWebFile $packageName "$appDir\$packageName.exe" $url $url64

Install-ChocolateyPackage $packageName $installerType $installerArgs $url $url64
