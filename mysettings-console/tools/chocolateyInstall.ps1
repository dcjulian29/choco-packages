$packageName = "mysettings-console"
$toolDir = "$(Split-Path -parent $MyInvocation.MyCommand.Path)"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

$cmd = "$env:WINDIR\system32\reg.exe import $toolDir\registry.reg"

if (Get-ProcessorBits -eq 64) {
    $cmd = "$cmd /reg:64"
}

cmd /c "$cmd"
