$packageName = 'baretail'
$appDir = "$($env:SYSTEMDRIVE)\tools\apps\$($packageName)"
$url = "http://www.baremetalsoft.com/baretail/download.php?p=m"
$toolDir = "$(Split-Path -parent $MyInvocation.MyCommand.Path)"

try
{
    if (Test-Path $appDir)
    {
      Write-Output "Removing previous version of package..."
      Remove-Item "$($appDir)\*" -Recurse -Force
    }

    if (-not $(Test-Path $appDir)) {
        New-Item -Type Directory -Path $appDir | Out-Null
    }

    Get-ChocolateyWebFile $packageName "$appDir\baretail.exe" $url 

    if (Test-ProcessAdminRights) {
        . $toolDir\postInstall.ps1
    } else {
        Start-ChocolateyProcessAsAdmin ". $toolDir\postInstall.ps1"
    }

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
