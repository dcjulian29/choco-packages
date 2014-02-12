$packageName = "keepass"
$url = "http://superb-dca2.dl.sourceforge.net/project/keepass/KeePass%202.x/2.24/KeePass-2.24.zip"
$downloadPath = "$env:TEMP\chocolatey\$packageName"
$appDir = "$($env:ChocolateyInstall)\apps\$($packageName)"

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

    mkdir $appDir
    
    if (-not (Test-Path $downloadPath))
    {
        mkdir $downloadPath
    }

    Get-ChocolateyWebFile $packageName "$downloadPath\keepass.zip" $url
    Get-ChocolateyUnzip "$downloadPath\keepass.zip" "$appDir\"

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
