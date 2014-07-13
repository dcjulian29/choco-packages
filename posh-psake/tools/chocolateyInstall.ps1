$packageName = "posh-psake"
$release = "4.3.1"
$url = "https://github.com/psake/psake/archive/v$($release).zip"
$appDir = "$($env:UserProfile)\Documents\WindowsPowerShell\Modules\$packageName"
$downloadPath = "$env:TEMP\chocolatey\$packageName"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try
{
    if (Test-Path $appDir)
    {
      Write-Output "Removing previous version of package..."
      Remove-Item "$($appDir)" -Recurse -Force
    }

    if (-not (Test-Path $downloadPath))
    {
        New-Item -Type Directory -Path $downloadPath | Out-Null
    }

    Get-ChocolateyWebFile $packageName "$downloadPath\v$release.zip" $url
    Get-ChocolateyUnzip "$downloadPath\v$release.zip" "$downloadPath\"

    if (-not (Test-Path $appDir))
    {
        New-Item -Type Directory -Path $appDir | Out-Null
    }

    Copy-Item -Path "$downloadPath\$packageName-$release\*" -Destination "$appDir"

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
