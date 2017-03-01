$packageName = "executor"
$url = "http://www.1space.dk/executor/Executor.zip"
$appDir = "$($env:SYSTEMDRIVE)\tools\$($packageName)"
$downloadPath = "$env:TEMP\$packageName"

if (Test-Path $downloadPath) {
    Remove-Item $downloadPath -Recurse -Force | Out-Null
}

New-Item -Type Directory -Path $downloadPath | Out-Null

Download-File $url "$downloadPath\$packageName.zip"

if (Test-Path $appDir) {
  Write-Output "Removing previous version of package..."
  Remove-Item "$($appDir)\*" -Recurse -Force
}

New-Item -Type Directory -Path $appDir | Out-Null

Unzip-File "$downloadPath\$packageName.zip" "$appdir"

Copy-Item -Path "$PSScriptRoot\*.cmd" $appDir

$location = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"

$key = Get-Item $location

if ($key.GetValue("Executor", $null) -ne $null) {
    Remove-ItemProperty -Path $location -Name "Executor"
}

New-ItemProperty -Path $location -Name Executor `
    -Value "$env:SYSTEMDRIVE\Tools\executor\executor-run.cmd"

