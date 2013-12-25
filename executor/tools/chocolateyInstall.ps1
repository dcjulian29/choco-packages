$packageName = "executor"
$url = "http://www.1space.dk/executor/Executor.zip"
$appDir = "$($env:ChocolateyInstall)\apps\$($packageName)"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
    $ErrorActionPreference = "Stop"
}

try
{
    if (Test-Path $appDir)
    {
      Write-Output "Removing previous version of package..."
      Remove-Item "$($appDir)\*" -Recurse -Force
    }

    mkdir $appDir
    
    Install-ChocolateyZipPackage $packageName $url $(Split-Path -parent $appDir)

    $location = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"

    $key = Get-Item $location
    if ($key.GetValue("Executor", $null) -ne $null) {
        Remove-ItemProperty -Path $location -Name "Executor"
    }

    New-ItemProperty -Path $location -Name Executor -Value "$env:SYSTEMDRIVE\Tools\binaries\executor-run.cmd"

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
