$packageName = "mysettings-ipv6"
$packageDir = "$(Split-Path -parent $MyInvocation.MyCommand.Path)"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try
{
    $cmd = "reg.exe import $packageDir\registry.reg"
    
    if (Get-ProcessorBits -eq 64) {
        $cmd = "$cmd /reg:64"
    }

    if (Test-ProcessAdminRights) {
        Invoke-Expression $cmd
    } else {
        Start-ChocolateyProcessAsAdmin "$cmd"
    }

    Write-Output "You need to reboot to complete the action..."
    
    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
