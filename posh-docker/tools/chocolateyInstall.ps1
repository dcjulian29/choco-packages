$packageName = "posh-docker"
$url = "https://github.com/Microsoft/Docker-PowerShell/releases/download/v0.1.0/Docker.0.1.0.zip"
$appDir = "$($env:UserProfile)\Documents\WindowsPowerShell\Modules\docker"
$downloadPath = "$env:TEMP\$packageName"

if (Test-Path $downloadPath)
{
    Remove-Item -Path $downloadPath -Recurse -Force
}

New-Item -Type Directory -Path $downloadPath | Out-Null

(New-Object System.Net.WebClient).DownloadFile($url, "$downloadPath\$packageName.zip")

[System.Reflection.Assembly]::LoadWithPartialName("System.IO.Compression.FileSystem") | Out-Null
[System.IO.Compression.ZipFile]::ExtractToDirectory("$downloadPath\$packageName.zip", "$downloadPath\$packageName")

if (Test-Path $appDir)
{
  Write-Output "Removing previous version of package..."
  Remove-Item "$($appDir)" -Recurse -Force
}

New-Item -Type Directory -Path $appDir | Out-Null

Copy-Item -Path "$downloadPath\$packageName\*" -Destination "$appDir"
