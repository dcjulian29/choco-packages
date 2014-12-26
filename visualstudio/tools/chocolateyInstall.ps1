$packageName = "visualstudio"
$toolDir = "$(Split-Path -parent $MyInvocation.MyCommand.Path)"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try
{
    Write-Verbose "Visual Studio Virtual Package."
    Write-Verbose "Packages depend on this package instead of the specific 'edition' package."

    Write-Output "Checking for Visual Studio 2013..."
    
    if (Test-Path "$env:SYSTEMDRIVE\Program Files (x86)") {
        $pf = "$env:SYSTEMDRIVE\Program Files (x86)"
    } else {
        $pf = "$env:SYSTEMDRIVE\Program Files (x86)"
    }
    
    if (-not (Test-Path "$pf\Microsoft Visual Studio 12.0\Common7\IDE\devenv.exe")) {
        throw "Visual Studio is not installed, please install one of the 'edition' packages."
    }
    
    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
