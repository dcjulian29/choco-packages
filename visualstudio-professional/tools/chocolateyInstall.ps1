$packageName = "visualstudio-professional"
$installerType = "EXE"
$installerArgs = "/PASSIVE /NORESTART"
$url = "http://download.microsoft.com/download/F/3/C/F3C109C2-8442-477A-A442-04A175870137/vs_professional.exe"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try
{
    Install-ChocolateyPackage $packageName $installerType $installerArgs $url -validExitCodes @(0, 3010)
    
    Start-Sleep -Seconds 5

    $cmd = @"

Get-Process -Name 'MobileTools_EmulatorWP81' -ErrorAction SilentlyContinue | Stop-Process

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
