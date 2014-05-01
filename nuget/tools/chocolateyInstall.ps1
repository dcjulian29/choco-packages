$packageName = "nuget"
$url = "http://nuget.codeplex.com/downloads/get/757017"
$appDir = "$($env:ChocolateyInstall)\apps\$($packageName)"
$exe = "$($appDir)\$($packageName).exe"

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
    
    Get-ChocolateyWebFile $packageName $exe $url

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
