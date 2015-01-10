$packageName = "ffmpeg"
$url = "http://ffmpeg.zeranoe.com/builds/win32/static/ffmpeg-20150109-git-d1c6b7b-win32-static.7z"
$url64 = "http://ffmpeg.zeranoe.com/builds/win64/static/ffmpeg-20150109-git-d1c6b7b-win64-static.7z"
$downloadPath = "$($env:TEMP)\chocolatey\$($packageName)"
$appDir = "$($env:SYSTEMDRIVE)\tools\apps\$($packageName)"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try {
    if (Test-Path $appDir)
    {
        Write-Output "Removing previous version of package..."
        Remove-Item "$($appDir)" -Recurse -Force
    }

    New-Item -Type Directory -Path $appDir | Out-Null
    
    if (-not (Test-Path $downloadPath))
    {
        New-Item -Type Directory -Path $downloadPath | Out-Null
    }

    Get-ChocolateyWebFile $packageName "$downloadPath\$packageName.7z" $url $url64
    Get-ChocolateyUnzip "$downloadPath\$packageName.7z" "$downloadPath\"

    $extractPath = $(Get-ChildItem -Directory -Path $downloadPath | Select-Object -First 1).Name

    Copy-Item -Path "$($downloadPath)\$($extractPath)\bin\*" -Destination "$appDir" -Recurse
    Copy-Item -Path "$($downloadPath)\$($extractPath)\licenses" -Destination "$appDir" -Recurse
    Copy-Item -Path "$($downloadPath)\$($extractPath)\doc" -Destination "$appDir" -Recurse
    Copy-Item -Path "$($downloadPath)\$($extractPath)\presets" -Destination "$appDir" -Recurse
    Copy-Item -Path "$($downloadPath)\$($extractPath)\README.txt" -Destination "$appDir"

    Write-ChocolateySuccess $packageName
} catch {
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
