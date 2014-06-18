$packageName = "itunes"
$installerArgs = "/quiet /passive /norestart"

$url = 'https://secure-appldnld.apple.com/iTunes11/031-02995.20140528.Tadim/iTunesSetup.exe'
$url64 = 'https://secure-appldnld.apple.com/iTunes11/031-02993.20140528.Pu4r5/iTunes64Setup.exe'

$downloadPath = "$env:TEMP\chocolatey\$packageName"
$errorCode = @(0, 3010)

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try
{
    if (Get-Process 'iTunes' -ea SilentlyContinue) {
        Stop-Process -processname 'iTunes'
    }

    if (-not (Test-Path $downloadPath)) {
        New-Item -Type Directory -Path $downloadPath | Out-Null
    }

    Get-ChocolateyWebFile $packageName "$downloadPath\$packageName.zip" $url $url64
    Get-ChocolateyUnzip "$downloadPath\$packageName.zip" "$downloadPath\"

    if (Get-ProcessorBits -eq 64) {
        $applemobiledevicesupport = "$downloadPath\AppleMobileDeviceSupport64.msi"
        $bonjour = "$downloadPath\Bonjour64.msi" 
        $itunes = "$downloadPath\iTunes64.msi"
    } else {
        $applemobiledevicesupport = "$downloadPath\AppleMobileDeviceSupport.msi"
        $bonjour = "$downloadPath\Bonjour.msi"
        $itunes = "$downloadPath\iTunes.msi" 
    }

    Install-ChocolateyInstallPackage "appleapplicationsupport" "MSI" $installerArgs `
        "$downloadPath\AppleApplicationSupport.msi" -ValidExitCodes $errorCode

    Install-ChocolateyInstallPackage "applemobiledevicesupport" "MSI" $installerArgs `
        $applemobiledevicesupport -ValidExitCodes $errorCode

    Install-ChocolateyInstallPackage "bonjour" "MSI" $installerArgs `
        $bonjour -ValidExitCodes $errorCode

    Install-ChocolateyInstallPackage $packageName "MSI" $installerArgs `
        $itunes -ValidExitCodes $errorCode

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
