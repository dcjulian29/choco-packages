$packageName = 'lastpass'
$appDir = "$($env:SYSTEMDRIVE)\tools\apps\$($packageName)"
$url = "https://lastpass.com/pocket.exe"

if (Test-Path $appDir)
{
  Write-Output "Removing previous version of package..."
  Remove-Item "$($appDir)\*" -Recurse -Force
}

if (-not $(Test-Path $appDir)) {
    New-Item -Type Directory -Path $appDir | Out-Null
}

Get-ChocolateyWebFile $packageName "$appDir\pocket.exe" $url 
