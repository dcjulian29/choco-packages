$packageName = "posh-git"
$release = "0.4"
$url = "https://github.com/dahlbyk/posh-git/archive/v$($release).zip"
$appDir = "$($env:UserProfile)\Documents\WindowsPowerShell\Modules\$packageName"
$downloadPath = "$env:TEMP\chocolatey\$packageName"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
    $ErrorActionPreference = "Stop"
}

try
{
    if (Test-Path $appDir)
    {
        Write-Output "Removing previous version of package..."
        Remove-Item "$($appDir)" -Recurse -Force
    }

    if (-not Test-Path $downloadPath)
    {
        mkdir $downloadPath
    }

    Get-ChocolateyWebFile $packageName "$downloadPath\v$release.zip" $url
    Get-ChocolateyUnzip "$downloadPath\v$release.zip" "$downloadPath\"

    mkdir $appDir

    Copy-Item -Path "$downloadPath\$packageName-$release\*" -Destination "$appDir"

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
