$packageName = "syncthing"
$url = "https://github.com/syncthing/syncthing/releases/download/v0.12.22/syncthing-windows-386-v0.12.22.zip"
$url64 = "https://github.com/syncthing/syncthing/releases/download/v0.12.22/syncthing-windows-amd64-v0.12.22.zip"
$downloadPath = "$($env:TEMP)\chocolatey\$($packageName)"
$appDir = "$($env:SYSTEMDRIVE)\tools\apps\$($packageName)"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try {
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

        Push-Location "$downloadPath\syncthing-windows-amd64-v*"

        Copy-Item -Path "*" -Destination "$appDir\" -Recurse -Container

        Pop-Location

        $location = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"

        $key = Get-Item $location
        if ($key.GetValue($packageName, $null) -ne $null) {
            Remove-ItemProperty -Path $location -Name $packageName
        }

        New-ItemProperty -Path $location -Name $packageName -Value "$appdir\syncthing.exe -no-console -no-browser"
    }

    Write-ChocolateySuccess $packageName
} catch {
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
