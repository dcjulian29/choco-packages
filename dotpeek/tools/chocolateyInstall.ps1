$packageName = "dotpeek"
$url = "http://download.jetbrains.com/resharper/dotPeek32_10.0.1.exe"
$url64 = "http://download.jetbrains.com/resharper/dotPeek64_10.0.1.exe"
$appDir = "$($env:SYSTEMDRIVE)\tools\apps\$($packageName)"
$optPath = "$env:AppData\JetBrains\Shared\vAny"
$optFile = "GlobalSettingsStorage.DotSettings"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

if (Test-Path $appDir) {
    Write-Output "Removing previous version of package..."
    Remove-Item "$($appDir)" -Recurse -Force
}

New-Item -Type Directory -Path $appDir | Out-Null

Get-ChocolateyWebFile $packageName "$appDir\$packageName.exe" $url $url64

if (-not (Test-Path $optPath)) {
    New-Item -Type Directory -Path $optPath | Out-Null
}

@"
<wpf:ResourceDictionary xml:space="preserve" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:s="clr-namespace:System;assembly=mscorlib" xmlns:ss="urn:shemas-jetbrains-com:settings-storage-xaml" xmlns:wpf="http://schemas.microsoft.com/winfx/2006/xaml/presentation">
  <s:Boolean x:Key="/Default/DotPeek/DotPeekLicenseAgreement/Accepted/@EntryValue">True</s:Boolean>
"@ > $optPath\$optFile
