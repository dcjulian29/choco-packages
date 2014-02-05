$packageName = "searchmyfiles"
$url = "http://www.nirsoft.net/utils/searchmyfiles.zip"
$url64 = "http://www.nirsoft.net/utils/searchmyfiles-x64.zip"
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

    mkdir $appDir | Out-Null
    
    if (-not (Test-Path $downloadPath))
    {
        mkdir $downloadPath | Out-Null
    }

    Get-ChocolateyWebFile $packageName "$downloadPath\$packageName.zip" $url $url64
    Get-ChocolateyUnzip "$downloadPath\$packageName.zip" "$appDir\"

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
