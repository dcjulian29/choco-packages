$packageName = "colormania"
$url = "http://www.blacksunsoftware.com/downloads/Colormania.zip"
$downloadPath = "$($env:TEMP)\chocolatey\$($packageName)"
$appDir = "$($env:SYSTEMDRIVE)\tools\apps\$($packageName)"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try {
    if (-not (Test-Path $downloadPath)) {
        New-Item -Type Directory -Path $downloadPath | Out-Null
    }

    Get-ChocolateyWebFile $packageName "$downloadPath\$packageName.zip" $url
    Get-ChocolateyUnzip "$downloadPath\$packageName.zip" "$downloadPath\colormania"

    if (Test-Path $appDir) {
        Write-Output "Removing previous version of package..."
        Remove-Item -Path $appDir -Recurse -Force
    }

    New-Item -Type Directory -Path $appDir | Out-Null

    Copy-Item -Path "$downloadPath\colormania\*" -Destination "$appDir\" -Recurse -Container

    Write-ChocolateySuccess $packageName
} catch {
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
