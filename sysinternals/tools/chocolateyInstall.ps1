$packageName = 'sysinternals'
$downloadPath = "$env:TEMP\$packageName"
$appDir = "$($env:SYSTEMDRIVE)\tools\apps\$($packageName)"
$toolDir = "$(Split-Path -parent $MyInvocation.MyCommand.Path)"
$url = 'https://download.sysinternals.com/files/SysinternalsSuite.zip'

if (Test-Path $downloadPath) {
    Remove-Item $downloadPath -Recurse -Force | Out-Null
}

New-Item -Type Directory -Path $downloadPath | Out-Null

Download-File $url "$downloadPath\$packageName.zip"

Unzip-File "$downloadPath\$packageName.zip" "$downloadPath\"

if (Test-Path $appDir) {
  Write-Output "Removing previous version of package..."
  Remove-Item "$($appDir)" -Recurse -Force
}

New-Item -Type Directory -Path $appDir | Out-Null

Get-ChildItem -Path $downloadPath -Exclude "$packageName.zip" | Copy-Item -Destination "$appDir"

Invoke-ElevatedExpression -Command ". $toolDir\postInstall.ps1"
