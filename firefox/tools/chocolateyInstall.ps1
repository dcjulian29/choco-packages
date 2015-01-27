$packageName = "firefox"
$installerType = "EXE"
$installerArgs = "-ms"
$url = "https://download.mozilla.org/?product=firefox-35.0.1-SSL&os=win&lang=en-US"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try {
    $uninstall64 = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\'
    $uninstall32 = 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\'
     
    $uninstall = $(Get-ChildItem $uninstall).Name
     
    if (Test-Path $uninstall32) {
        $uninstall += $(Get-ChildItem $uninstall32).Name
    }
     
    $uninstall = $uninstall -match "Mozilla Firefox [\d\.]+ \([^\s]+ [a-zA-Z\-]+\)" | Select -First 1
      
    if ($uninstall) {
        Write-Output "Firefox is already installed and will update itself, no need to update via package..."
    } else {
        Install-ChocolateyPackage $packageName $installerType $installerArgs $url

        Start-ChocolateyProcessAsAdmin "Remove-Item '$($env:PUBLIC)\Desktop\Mozilla Firefox.lnk' -Force"
    }
    
    Write-ChocolateySuccess $packageName
} catch {
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
