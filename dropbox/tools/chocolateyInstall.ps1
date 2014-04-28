$packageName = "dropbox"
$installerType = "EXE"
$url = "https://www.dropbox.com/download?src=index&plat=win"
$downloadPath = "$env:TEMP\chocolatey\$packageName"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
    $ErrorActionPreference = "Stop"
}

try
{
    if (-not (Test-Path $downloadPath)) {
        mkdir $downloadPath | Out-Null
    }

    Get-ChocolateyWebFile $packageName "$downloadPath\$packageName.$installerType" $url

    Start-Process "$downloadPath\$packageName.$installerType" -NoNewWindow

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
