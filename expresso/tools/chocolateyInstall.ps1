$packageName = "expresso"
$installerType = "MSI"
$installerArgs = "/qb"
$url = "http://www.ultrapico.com/ExpressoSetup3.msi"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

if (-not (Test-Path "HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v3.5")) {
    if (Test-ProcessAdminRights) {
        & Enable-WindowsOptionalFeature -All -FeatureName NetFx3 -Online
    } else {
        Start-ChocolateyProcessAsAdmin "Enable-WindowsOptionalFeature -All -FeatureName NetFx3 -Online"
    }
} else {
    Write-Host "Microsoft .Net 3.5 Framework is already installed on this system..."
} 

Install-ChocolateyPackage $packageName $installerType $installerArgs $url $url
