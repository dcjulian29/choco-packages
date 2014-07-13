$packageName = "nant"
$downloadPath = "$env:TEMP\chocolatey\$packageName"
$appDir = "$($env:SYSTEMDRIVE)\tools\apps\$($packageName)"
$version = "0.92"

$url = "http://sourceforge.net/projects/nant/files/nant/$($version)/nant-$($version)-bin.zip/download"

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

    Get-ChocolateyWebFile $packageName "$downloadPath\$packageName.zip" $url
    Get-ChocolateyUnzip "$downloadPath\$packageName.zip" "$downloadPath\"

    if (-not (Test-Path $appDir)) {
        New-Item -Type Directory -Path $appDir | Out-Null
    }

    Copy-Item -Path "$($downloadPath)\$($packageName)-$($version)\bin\*" -Destination "$($appDir)" -Recurse -Container
    Copy-Item -Path "$($downloadPath)\$($packageName)-$($version)\doc\help" -Destination "$($appDir)" -Recurse -Container
    Copy-Item -Path "$($downloadPath)\$($packageName)-$($version)\schema\*" -Destination "$($appDir)" -Recurse -Container
    Copy-Item -Path "$($downloadPath)\$($packageName)-$($version)\*.txt" -Destination "$($appDir)"

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
