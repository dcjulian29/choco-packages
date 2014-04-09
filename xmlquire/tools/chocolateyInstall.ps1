$packageName = "xmlquire"
$url = "http://qutoric.com/coherentweb/resources/XMLQuireWin8.zip"
$appDir = "$($env:ChocolateyInstall)\apps\$($packageName)"
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

    mkdir $appDir | Out-Null
    
    if (-not (Test-Path $downloadPath))
    {
        mkdir $downloadPath | Out-Null
    }

    Get-ChocolateyWebFile $packageName "$downloadPath\$packageName.zip" $url

    Push-Location $downloadPath

    & 'C:\Program Files\7-Zip\7z.exe' x $downloadPath\$packageName.zip

    Copy-Item -Path "$downloadPath\Application Files\*\*" -Destination "$appDir" -Recurse -Container

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
