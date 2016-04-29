﻿$packageName = "java"
$searchFilter = { ($_.GetValue('DisplayName') -like '*Java*') }  
$toolDir = "$(Split-Path -parent $MyInvocation.MyCommand.Path)"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

$uninstallPaths = @(
    'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall', 
    'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall') 

foreach ($path in $uninstallPaths) { 
    if ( -not ($path -like "*JavaScript*")) {
        if (Test-Path $path) { 
            Get-ChildItem $path | Where-Object $searchFilter | `
                Where-Object { $_.GetValue('UninstallString') } | `
                Foreach-Object { 
                    Start-Process -Wait `
                        "${env:WINDIR}\System32\msiexec.exe" "/x $($_.PSChildName) /qb"
                }
        }
    } 
} 

if (Test-ProcessAdminRights) {
    . $toolDir\postUninstall.ps1
} else {
    Start-ChocolateyProcessAsAdmin ". $toolDir\postUninstall.ps1"
}
