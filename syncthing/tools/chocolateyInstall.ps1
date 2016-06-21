$packageName = "syncthing"
$url = "https://github.com/syncthing/syncthing/releases/download/v0.13.7/syncthing-windows-386-v0.13.7.zip"
$url64 = "https://github.com/syncthing/syncthing/releases/download/v0.13.7/syncthing-windows-amd64-v0.13.7.zip"
$downloadPath = "$($env:TEMP)\chocolatey\$($packageName)"
$appDir = "$($env:SYSTEMDRIVE)\tools\apps\$($packageName)"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

if (-not (Test-Path "$appDir\syncthing.exe")) {
    if (-not (Test-Path $downloadPath)) {
        New-Item -Type Directory -Path $downloadPath | Out-Null
    }

    Get-ChocolateyWebFile $packageName "$downloadPath\$packageName.zip" $url $url64
    Get-ChocolateyUnzip "$downloadPath\$packageName.zip" "$downloadPath\"

    if (Test-Path $appDir) {
        Write-Output "Removing previous version of package..."
        Remove-Item -Path $appDir -Recurse -Force
    }

    New-Item -Type Directory -Path $appDir | Out-Null

    if (Test-Path "$downloadPath\syncthing-windows-amd64-v*") {
        Push-Location "$downloadPath\syncthing-windows-amd64-v*"
    }

    if (Test-Path "$downloadPath\syncthing-windows-386-v*") {
        Push-Location "$downloadPath\syncthing-windows-386-v*"
    }

    if (Test-Path ".\syncthing.exe" ) {
        Copy-Item -Path "*" -Destination "$appDir\" -Recurse -Container
    } else {
        throw "Syncthing executable not found! Did the download fail?"
    }

    Pop-Location

    $location = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"

    $key = Get-Item $location
    if ($key.GetValue($packageName, $null) -ne $null) {
        Remove-ItemProperty -Path $location -Name $packageName
    }

    New-ItemProperty -Path $location -Name $packageName -Value "$appdir\syncthing.exe -no-console -no-browser"
} else {
    Write-Warning "Syncthing is already installed and should self-update."
    Write-Output "If you are trying to update between major versions, uninstall previous version first..."
}