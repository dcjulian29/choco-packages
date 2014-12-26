$packageName = "vscommunity"
$installerType = "EXE"
$installerArgs = "/PASSIVE /NORESTART"
$url = "http://download.microsoft.com/download/7/1/B/71BA74D8-B9A0-4E6C-9159-A8335D54437E/vs_community.exe"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try
{
    Install-ChocolateyPackage $packageName $installerType $installerArgs $url -validExitCodes @(0, 3010)
    
    Start-Sleep -Seconds 5

    $cmd = @"

Get-Process -Name 'Windows Phone 8.1 Emulators - ENU' -ErrorAction SilentlyContinue `
    | Stop-Process -Force

Push-Location "C:\ProgramData\Package Cache\{166a69f6-6512-47ea-a342-17d954fc059a}"
& ".\MobileTools_EmulatorWP81.exe" /uninstall /quiet
Pop-Location

"@    
    
    if (Test-ProcessAdminRights) {
        Invoke-Expression $cmd
    } else {
        Start-ChocolateyProcessAsAdmin $cmd
    }    

    & choco.exe install visualstudio -version 2013.4
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
