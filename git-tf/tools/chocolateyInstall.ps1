$packageName = "git-tf"
$url = "http://download.microsoft.com/download/A/E/2/AE23B059-5727-445B-91CC-15B7A078A7F4/git-tf-2.0.3.20131219.zip"
$downloadPath = "$($env:TEMP)\chocolatey\$($packageName)"
$appDir = "$($env:SYSTEMDRIVE)\tools\apps\$($packageName)"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

Get-ChocolateyWebFile $packageName "$downloadPath\$packageName.zip" $url
Get-ChocolateyUnzip "$downloadPath\$packageName.zip" "$downloadPath\"


if (Test-Path $appDir)
{
    Write-Output "Removing previous version of package..."
    Remove-Item "$($appDir)" -Recurse -Force
}

New-Item -Type Directory -Path $appDir | Out-Null
    
Copy-Item -Path "$downloadPath\git-tf-2.0.3.20131219\*" -Destination "$appDir\" -Recurse -Container
