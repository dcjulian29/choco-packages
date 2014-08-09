$packageName = "visualstudio"
$toolDir = "$(Split-Path -parent $MyInvocation.MyCommand.Path)"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try
{
    Write-Verbose "Visual Studio Virtual Package."
    Write-Verbose "Packages depend on this package instead of the specific 'edition' package."

    # Remove Windows Phone Emulator
    if (Test-Path "$($env:ALLUSERSPROFILE)\Package Cache\{940596e5-652a-4970-8a5a-492e73ed0fbb}") {
        Push-Location "$($env:ALLUSERSPROFILE)\Package Cache\{940596e5-652a-4970-8a5a-492e73ed0fbb}" 
        If (Test-Path "MobileTools_EmulatorWP81.exe") {
            Start-ChocolateyProcessAsAdmin "./MobileTools_EmulatorWP81.exe /Uninstall /Passive /NoRestart"
        }
        Pop-Location
    }
    
    Remove-Item "$($env:ALLUSERSPROFILE)\Package Cache\{940596e5-652a-4970-8a5a-492e73ed0fbb}" -Force -Recurse

    # Remove Visual Studio Components that I don't want or use...
    Start-ChocolateyProcessAsAdmin "$toolDir\uninstallPhonePackages.bat"
    
	Install-ChocolateyPinnedTaskBarItem "${env:ProgramFiles(x86)}\Microsoft Visual Studio 12.0\Common7\IDE\devenv.exe"    
    
    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
