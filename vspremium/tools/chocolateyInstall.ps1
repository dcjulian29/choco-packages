$packageName = "vspremium"
$installerType = "EXE"
$installerArgs = "/PASSIVE /NORESTART"
$url = "http://download.microsoft.com/download/B/B/F/BBFCF1F6-D74C-4B1C-8CD8-D41512EEEC85/vs_premium.exe"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try
{
    Install-ChocolateyPackage $packageName $installerType $installerArgs $url
    
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

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
