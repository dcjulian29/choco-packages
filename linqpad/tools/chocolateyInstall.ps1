$packageName = "linqpad"
$url = "http://www.linqpad.net/GetFile.aspx?LINQPad4.zip"
$appDir = "$($env:ChocolateyInstall)\apps\$($packageName)"
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

    New-Item -Type Directory -Path $appDir | Out-Null
    
    if (Test-Path $downloadPath)
    {
        Remove-Item $downloadPath -Recurse -Force
    }

    New-Item -Type Directory -Path $downloadPath | Out-Null
    Get-ChocolateyWebFile $packageName "$downloadPath\$packageName.zip" $url

    Push-Location $downloadPath

    & 'C:\Program Files\7-Zip\7z.exe' x $downloadPath\$packageName.zip

    Pop-Location
    
    Copy-Item -Path "$downloadPath\LINQPad.exe*" -Destination "$appDir" -Recurse -Container

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
