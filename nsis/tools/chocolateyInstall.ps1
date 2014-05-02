$packageName = "nsis"
$downloadPath = "$env:TEMP\chocolatey\$packageName"
$appDir = "$($env:ChocolateyInstall)\apps\$($packageName)"
$version = "2.46"

$url = "http://sourceforge.net/projects/nsis/files/NSIS%202/$($version)/nsis-$($version).zip/download"

$simplesc = "http://nsis.sourceforge.net/mediawiki/images/c/c9/NSIS_Simple_Service_Plugin_1.30.zip"
$simplefc = "http://nsis.sourceforge.net/mediawiki/images/f/f1/NSIS_Simple_Firewall_Plugin_1.19.zip"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
    $ErrorActionPreference = "Stop"
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

    Copy-Item -Path "$($downloadPath)\$($packageName)-$($version)\*" -Destination "$($appDir)" -Recurse -Container

    # Plugins

    Get-ChocolateyWebFile $packageName "$($downloadPath)\simplesc.zip" $simplesc
    New-Item -Type Directory -Path "$($downloadPath)\SimpleSC" | Out-Null
    Get-ChocolateyUnzip "$($downloadPath)\simplesc.zip" "$($downloadPath)\SimpleSC"
    Copy-Item -Path "$($downloadPath)\SimpleSC\SimpleSC.dll" -Destination "$($appDir)\Plugins\"

    Get-ChocolateyWebFile $packageName "$($downloadPath)\simplefc.zip" $simplefc
    New-Item -Type Directory -Path "$($downloadPath)\SimpleFC" | Out-Null
    Get-ChocolateyUnzip "$($downloadPath)\simplefc.zip" "$($downloadPath)\SimpleFC"
    Copy-Item -Path "$($downloadPath)\SimpleFW\SimpleFC.dll" -Destination "$($appDir)\Plugins\"

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
