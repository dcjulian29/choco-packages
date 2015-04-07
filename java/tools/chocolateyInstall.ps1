﻿$packageName = "java"
$installerType = "exe"
$installerArgs = "/s REBOOT=Suppress WEB_JAVA=0"

$url = "http://javadl.sun.com/webapps/download/AutoDL?BundleId=104766"
$url64 = "http://javadl.sun.com/webapps/download/AutoDL?BundleId=104768"

$toolDir = "$(Split-Path -parent $MyInvocation.MyCommand.Path)"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try {
    Write-Output "Checking for and uninstalling previous versions of Java..."

    . $toolDir\chocolateyUninstall.ps1

    Install-ChocolateyPackage $packageName $installerType $installerArgs $url
  
    $path = Join-Path $env:ProgramFiles "Java"
    
    if ((Get-WmiObject Win32_Processor).AddressWidth -eq 64) { 
        Install-ChocolateyPackage $packageName $installerType $installerArgs "" $url64
        $path = Join-Path $env:ProgramW6432 "Java"
    }

    $path  = (Get-ChildItem -Path $path -Recurse -Include "bin").FullName `
        | Sort-Object | Select-Object -Last 1

    $path = Split-Path -Path $path -Parent
    $cmd = "[Environment]::SetEnvironmentVariable('JAVA_HOME','$path', 'Machine')"

    if (Test-ProcessAdminRights) {
        Invoke-Expression $cmd
    } else {
        Start-ChocolateyProcessAsAdmin $cmd
    }

    Write-ChocolateySuccess $packageName
} catch {
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
