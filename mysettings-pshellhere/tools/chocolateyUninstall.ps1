$packageName = "mysettings-pshellhere"
$toolDir = "$(Split-Path -parent $MyInvocation.MyCommand.Path)"

try
{
    if (Test-ProcessAdminRights) {
        . $toolDir\postUninstall.ps1
    } else {
        Start-ChocolateyProcessAsAdmin ". $toolDir\postUninstall.ps1"
    }

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
