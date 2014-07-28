$packageName = "mysettings-visualstudio"
$installerType = "EXE"
$installerArgs = "/PASSIVE /NORESTART"
$toolDir = "$(Split-Path -parent $MyInvocation.MyCommand.Path)"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try {
    # Remove Windows Phone Emulator
    Push-Location "$($env:ALLUSERSPROFILE)\Package Cache\{940596e5-652a-4970-8a5a-492e73ed0fbb}" 
    Start-ChocolateyProcessAsAdmin "./MobileTools_EmulatorWP81.exe /Uninstall /Passive /NoRestart"
    Pop-Location
    
    # Remove Visual Studio Components that I don't want or use...
    Start-ChocolateyProcessAsAdmin "$toolDir\uninstallPhonePackages.bat"

    # Download and install Components
    Install-ChocolateyPackage "Visual F# Tools" $installerType $installerArgs `
        http://download.microsoft.com/download/3/0/A/30A5D6DD-5B5C-4E06-B331-A88AA0B53150/FSharp_Bundle.exe"
    Install-ChocolateyPackage "Microsoft SQL Server Data Tools" $installerType $installerArgs `
        "http://download.microsoft.com/download/F/3/0/F3065AA6-1E2D-44B7-B412-4B2F0B109177/EN/SSDTSetup.exe"
    Install-ChocolateyPackage "Windows Azure Tools" $installerType $installerArgs `
        "http://download.microsoft.com/download/6/C/0/6C0725EF-D93F-4A2D-B040-9B7D8BDE06A1/WindowsAzureTools.vs120.exe"
    Install-ChocolateyPackage "Microsoft Visual Studio Team Foundation Server Power Tools" "MSI" $installerArgs `
        "http://visualstudiogallery.msdn.microsoft.com/f017b10c-02b4-4d6d-9845-58a06545627f/file/112253/3/Visual%20Studio%20Team%20Foundation%20Server%202013%20Update%202%20Power%20Tools%20.msi"

    # Install VSIX packages
    Install-ChocolateyVsixPackage "PerfWatson Monitor" "http://visualstudiogallery.msdn.microsoft.com/ad0897b3-7537-4c92-a38c-104b0e005206/file/75983/4/PerfWatsonMonitor.vsix"
    Install-ChocolateyVsixPackage "PostSharp" "http://visualstudiogallery.msdn.microsoft.com/a058d5d3-e654-43f8-a308-c3bdfdd0be4a/file/89212/44/PostSharp-3.1.46.vsix"
    Install-ChocolateyVsixPackage "SpecFlow for Visual Studio" "http://visualstudiogallery.msdn.microsoft.com/90ac3587-7466-4155-b591-2cd4cc4401bc/file/112721/3/TechTalk.SpecFlow.Vs2013Integration.vsix"
    Install-ChocolateyVsixPackage "VSColorOutput" "http://visualstudiogallery.msdn.microsoft.com/f4d9c2b5-d6d7-4543-a7a5-2d7ebabc2496/file/63103/7/VSColorOutput.vsix"
    Install-ChocolateyVsixPackage "Web Essentials" "http://visualstudiogallery.msdn.microsoft.com/56633663-6799-41d7-9df7-0f2a504ca361/file/105627/36/WebEssentials2013.vsix"
    Install-ChocolateyVsixPackage "xUnit.net runner for Visual Studio" "http://visualstudiogallery.msdn.microsoft.com/463c5987-f82b-46c8-a97e-b1cde42b9099/file/66837/19/xunit.runner.visualstudio.vsix"
    Install-ChocolateyVsixPackage "I Hate #Regions" "http://visualstudiogallery.msdn.microsoft.com/0ca60d35-1e02-43b7-bf59-ac7deb9afbca/file/69113/7/DisableRegions.vsix"
    Install-ChocolateyVsixPackage "JSLint.NET for Visual Studio" "http://visualstudiogallery.msdn.microsoft.com/ede12aa8-0f80-4e6f-b15c-7a8b3499370e/file/111592/15/JSLintNet.VisualStudio.1.6.3.vsix"
    Install-ChocolateyVsixPackage "Productivity Power Tools" "http://visualstudiogallery.msdn.microsoft.com/dbcb8670-889e-4a54-a226-a48a15e4cace/file/117115/4/ProPowerTools.vsix"
    Install-ChocolateyVsixPackage "SlowCheetah - XML Transforms" "http://visualstudiogallery.msdn.microsoft.com/69023d00-a4f9-4a34-a6cd-7e854ba318b5/file/55948/26/SlowCheetah.vsix"
    
	Install-ChocolateyPinnedTaskBarItem "${env:ProgramFiles(x86)}\Microsoft Visual Studio 12.0\Common7\IDE\devenv.exe"
    
    Write-ChocolateySuccess $packageName
} catch {
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
