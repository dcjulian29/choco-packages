$packageName = "webpi"
$installerType = "MSI"
$installerArgs = "/PASSIVE /NORESTART"
$url = "http://download.microsoft.com/download/C/F/F/CFF3A0B8-99D4-41A2-AE1A-496C08BEB904/WebPlatformInstaller_x86_en-US.msi"
$url64 = "http://download.microsoft.com/download/C/F/F/CFF3A0B8-99D4-41A2-AE1A-496C08BEB904/WebPlatformInstaller_amd64_en-US.msi"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try
{
    Install-ChocolateyPackage $packageName $installerType $installerArgs $url $url64

    $pdir = "C:\Program Files\Microsoft\Web Platform Installer"
    
    if (Get-ProcessorBits -eq 64) {
        $exe = "WebpiCmd-x64.exe"
    } else {
        $exe = "WebpiCmd.exe"
    }
    
    Set-Content "$($env:ChocolateyInstall)\bin\webpicmd.bat" "@""$pdir\$exe"" %*"
    
    Write-ChocolateySuccess $packageName
} catch {
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
