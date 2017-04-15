$packageName = "visualstudio"
$installerType = "EXE"
$installerArgs = "/PASSIVE /NORESTART"
$downloadPath = "$env:LOCALAPPDATA\Temp\$packageName"

$env:SEE_MASK_NOZONECHECKS = 1

$url = "http://download.microsoft.com/download/C/7/8/C789377D-7D49-4331-8728-6CED518956A0/vs_enterprise_ENU.exe"

if (Test-Path $downloadPath) {
    Remove-Item -Path $downloadPath -Recurse -Force
}

New-Item -Type Directory -Path $downloadPath | Out-Null

Download-File $url "$downloadPath\$packageName.$installerType"

Invoke-ElevatedCommand "$downloadPath\$packageName.$installerType" -ArgumentList $installerArgs -Wait

Remove-Item env:SEE_MASK_NOZONECHECKS -Force
