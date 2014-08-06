$packageName = "mysettings-visualstudio"
$installerType = "EXE"
$installerArgs = "/PASSIVE /NORESTART"
$toolDir = "$(Split-Path -parent $MyInvocation.MyCommand.Path)"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try {
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

    Push-Location $env:TEMP\chocolatey

    # Download and install Components
    Install-ChocolateyPackage "VisualFSharpTools" $installerType $installerArgs `
        "http://download.microsoft.com/download/3/0/A/30A5D6DD-5B5C-4E06-B331-A88AA0B53150/FSharp_Bundle.exe"
    Install-ChocolateyPackage "MicrosoftSQLServerDataTools" $installerType $installerArgs `
        "http://download.microsoft.com/download/F/3/0/F3065AA6-1E2D-44B7-B412-4B2F0B109177/EN/SSDTSetup.exe"
    Install-ChocolateyPackage "WindowsAzureTools" $installerType $installerArgs `
        "http://download.microsoft.com/download/6/C/0/6C0725EF-D93F-4A2D-B040-9B7D8BDE06A1/WindowsAzureTools.vs120.exe"
    Install-ChocolateyPackage "MicrosoftVisualStudioTeamFoundationServerPowerTools" "MSI" $installerArgs `
        "http://visualstudiogallery.msdn.microsoft.com/f017b10c-02b4-4d6d-9845-58a06545627f/file/112253/3/Visual%20Studio%20Team%20Foundation%20Server%202013%20Update%202%20Power%20Tools%20.msi"
    
    Pop-Location
    
	Install-ChocolateyPinnedTaskBarItem "${env:ProgramFiles(x86)}\Microsoft Visual Studio 12.0\Common7\IDE\devenv.exe"
    
    Write-ChocolateySuccess $packageName
} catch {
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
