$packageName = "ccnet"
$url = "https://julianscorner.com/downloads/CruiseControl.NET-1.8.5.0.zip"
$downloadPath = "$($env:TEMP)\chocolatey\$($packageName)"
$appDir = "$($env:SYSTEMDRIVE)\$($packageName)"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try {
    if (-not (Test-Path $downloadPath)) {
        New-Item -Type Directory -Path $downloadPath | Out-Null
    }

    Get-ChocolateyWebFile $packageName "$downloadPath\$packageName.zip" $url
    Get-ChocolateyUnzip "$downloadPath\$packageName.zip" "$downloadPath\"

    if (Test-Path $appDir) {
        Write-Output "Removing previous version of package..."
        if (Test-Path "$appDir\ccnet.config") {
            Write-Output "   however, saving previous configuration file..."
            Copy-Item "$appDir\ccnet.config" "$downloadPath\ccnet.config" -Force
        }

        Remove-Item -Path $appDir -Recurse -Force
    }

    New-Item -Type Directory -Path $appDir | Out-Null

    Copy-Item -Path "$downloadPath\Server\*" -Destination "$appDir\" -Recurse -Container

    if (Test-Path "$downloadPath\ccnet.config") {
        Write-Output "Restoring previous configuration file..."
        Move-Item "$downloadPath\ccnet.config" "$appDir\ccnet.config" -Force
    }

    Write-ChocolateySuccess $packageName
} catch {
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
