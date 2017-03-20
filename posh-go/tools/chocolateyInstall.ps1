$packageName = "posh-go"
$url = "https://github.com/cameronharp/Go-Shell/archive/master.zip"
$appDir = "$($env:UserProfile)\Documents\WindowsPowerShell\Modules\go"
$downloadPath = "$env:LOCALAPPDATA\Temp\$packageName"

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

Copy-Item -Path "$downloadPath\Go-Shell-master\*" -Destination "$appDir"

