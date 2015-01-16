$packageName = "posh-psake"
$release = "4.4.0"
$url = "https://codeload.github.com/psake/psake/zip/v$($release)"
$appDir = "$($env:SYSTEMDRIVE)\Program Files\WindowsPowerShell\Modules\psake"
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

    $cmd = "Copy-Item -Path `"$downloadPath\psake-$release\*`" -Destination `"$appDir`""

    if (Test-ProcessAdminRights) {
        Invoke-Expression $cmd
    } else {
        Start-ChocolateyProcessAsAdmin $cmd
    }    

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
