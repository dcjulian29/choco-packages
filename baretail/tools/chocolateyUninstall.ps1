$packageName = 'baretail'
$appDir = "$($env:ChocolateyInstall)\apps\$($packageName)"

try
{
    if (Test-Path $appDir)
    {
      Remove-Item "$($appDir)" -Recurse -Force
    }

    $exe = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)\postUninstall.ps1"
    Start-ChocolateyProcessAsAdmin ". $exe"

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
