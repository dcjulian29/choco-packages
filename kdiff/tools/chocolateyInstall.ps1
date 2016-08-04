$packageName = "kdiff"
$url = "https://julianscorner.com/downloads/KDiff3-32bit-Setup_0.9.98-3.exe"
$url64 = "https://julianscorner.com/downloads/KDiff3-64bit-Setup_0.9.98-2.exe"
$downloadPath = "$env:TEMP\chocolatey\$packageName"
$appDir = "$($env:SYSTEMDRIVE)\tools\apps\$($packageName)"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try
{
    if (Test-Path $downloadPath)
    {
        Remove-Item -Path $downloadPath -Recurse -Force
    }

    New-Item -Type Directory -Path $downloadPath | Out-Null

    Get-ChocolateyWebFile $packageName "$downloadPath\$packageName.7z" $url $url64

    New-Item -Type Directory -Path $downloadPath\$packageName | Out-Null

    Push-Location $downloadPath\$packageName

    & 'C:\Program Files\7-Zip\7z.exe' x $downloadPath\$packageName.7z

    if (Test-Path "`$_OUTDIR") {
        Copy-Item -Path "`$_OUTDIR\*" -Destination ".\" -Recurse -Container
        Remove-Item -Path "`$_OUTDIR" -Recurse -Force
    }

    Remove-Item -Path "`$APPDATA" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "`$PLUGINSDIR" -Recurse -Force -ErrorAction SilentlyContinue

    Remove-Item -Path "*.nsi" -Force -ErrorAction SilentlyContinue

    Pop-Location

    if (Test-Path $appDir)
    {
        Write-Output "Removing previous version of package..."
        Remove-Item "$($appDir)" -Recurse -Force
    }

    New-Item -Type Directory -Path $appDir | Out-Null
    
    Copy-Item -Path "$downloadPath\$packageName\*" -Destination "$appDir" -Recurse -Container

    #Set-Content -Path "$appDir\qt.conf" -Value "[Paths]"
    
    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
