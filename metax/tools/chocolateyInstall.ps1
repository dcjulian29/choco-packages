$packageName = "metax"
$installerType = "EXE"
$installerArgs = "/Q"
$url = "http://www.danhinsley.com/downloads/MetaXSetup.exe"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try
{
    if (-not (Test-Path "HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v3.5")) {
        Start-ChocolateyProcessAsAdmin "Enable-WindowsOptionalFeature -All -FeatureName NetFx3 -Online"
    } else {
        Write-Host "Microsoft .Net 3.5 Framework is already installed on this system..."
    } 

    Install-ChocolateyPackage $packageName $installerType $installerArgs $url

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
