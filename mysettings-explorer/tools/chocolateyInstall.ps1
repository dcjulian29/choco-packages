$packageName = "mysettings-explorer"
$toolDir = "$(Split-Path -parent $MyInvocation.MyCommand.Path)"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try
{
    $cmd = "$env:WINDIR\system32\reg.exe import $toolDir\registry.reg"
    
    if (Get-ProcessorBits -eq 64) {
        $cmd = "$cmd /reg:64"
    }
    
    cmd /c "$cmd"
    
#    if (Test-ProcessAdminRights) {
#        . $toolDir\postInstall.ps1
#    } else {
#        Start-ChocolateyProcessAsAdmin ". $toolDir\postInstall.ps1"
#    }

    Write-Output "You need to reboot to complete the action..."

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
