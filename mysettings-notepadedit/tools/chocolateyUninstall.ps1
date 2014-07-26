$packageName = "mysettings-notepadedit"
$toolDir = "$(Split-Path -parent $MyInvocation.MyCommand.Path)"

try
{
    Start-ChocolateyProcessAsAdmin ". $toolDir\postUninstall.ps1"

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
