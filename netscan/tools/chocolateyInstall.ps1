$packageName = "netscan"
$url = "http://www.softperfect.com/download/freeware/netscan.zip"
$downloadPath = "$env:TEMP\chocolatey\$packageName"
$appDir = "$($env:ChocolateyInstall)\apps\$($packageName)"
$toolDir = "$(Split-Path -parent $MyInvocation.MyCommand.Path)"

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

    New-Item -Type Directory -Path $appDir | Out-Null
    
    if (-not (Test-Path $downloadPath))
    {
        New-Item -Type Directory -Path $downloadPath | Out-Null
    }

    Get-ChocolateyWebFile $packageName "$downloadPath\$packageName.zip" $url

    if (Test-Path "${env:ProgramFiles}") {
        $bits = "32-Bit"
    }

    if (Test-Path "${env:ProgramFiles(x86)}") {
        $bits = "64-Bit"
    }
    
    Get-ChocolateyUnzip "$downloadPath\$packageName.zip" "$downloadPath\"

    Get-ChildItem -Path $downloadPath\$bits -Include $keep -Recurse | Copy-Item -Destination "$appDir"

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
