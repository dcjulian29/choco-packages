$packageName = "posh-go"
$url = "https://github.com/cameronharp/Go-Shell/archive/master.zip"
$appDir = "$($env:UserProfile)\Documents\WindowsPowerShell\Modules\go"
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

    Get-ChocolateyWebFile $packageName "$downloadPath\master.zip" $url
    Get-ChocolateyUnzip "$downloadPath\master.zip" "$downloadPath\"

    New-Item -Type Directory -Path $appDir | Out-Null

    Copy-Item -Path "$downloadPath\Go-Shell-master\*" -Destination "$appDir"

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
