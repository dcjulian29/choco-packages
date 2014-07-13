$packageName = "webpi"
$downloadPath = "$env:TEMP\chocolatey\$packageName"
$appDir = "$($env:SYSTEMDRIVE)\tools\apps\$($packageName)"
$lessmsi = "https://github.com/activescott/lessmsi/releases/download/v1.1.7/lessmsi-v1.1.7.zip"
$url   = 'http://download.microsoft.com/download/7/0/4/704CEB4C-9F42-4962-A2B0-5C84B0682C7A/WebPlatformInstaller_x86_en-US.msi'
$url64 = 'http://download.microsoft.com/download/7/0/4/704CEB4C-9F42-4962-A2B0-5C84B0682C7A/WebPlatformInstaller_amd64_en-US.msi'


if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try
{
    if (Test-Path $appDir)
    {
      Remove-Item "$($appDir)" -Recurse -Force
    }

    if (-not (Test-Path $downloadPath)) {
        New-Item -Type Directory -Path $downloadPath | Out-Null
    }

    Get-ChocolateyWebFile $packageName "$downloadPath\lessmsi.zip" $lessmsi $lessmsi
    Get-ChocolateyUnzip "$downloadPath\lessmsi.zip" "$downloadPath\"

    if (-not (Test-Path $appDir)) {
        New-Item -Type Directory -Path $appDir | Out-Null
    }

    Get-ChocolateyWebFile $packageName "$downloadPath\$packageName.msi" $url $url64

    Start-Process -FilePath "$($downloadPath)\lessmsi.exe" -WorkingDirectory $downloadPath `
        -NoNewWindow -Wait -ArgumentList "x ""$($downloadPath)\$($packageName).msi"" .\"

    Copy-Item 'C:\temp\chocolatey\webpi\SourceDir\Microsoft\Web Platform Installer\*' $appDir -Recurse -Container

    Set-Content "$($env:SYSTEMDRIVE)\tools\bin\webpicmd.bat" "@%SYSTEMDRIVE%\tools\apps\webpi\WebpiCmd.exe %*"
    
    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
