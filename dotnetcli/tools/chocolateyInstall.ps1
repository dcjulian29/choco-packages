$packageName = "dotnetcli"
$installerType = 'msi'
$installerArgs = '/passive'
$url = 'https://dotnetcli.blob.core.windows.net/dotnet/dev/Installers/Latest/dotnet-win-x64.latest.msi'
$path = 'HKLM:\SOFTWARE\dotnet\Setup'
$version = "1.0.0"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

if (Test-Path $Path) {
    $installedversion =  (Get-ItemProperty -Path $Path -Name Version).Version
} else {
    $installedversion = "0.0.0"
}

if (-not ($installedversion.StartsWith($version))) {
    if (Get-ProcessorBits(32)) {
        Write-Warning "32 bit Microsoft .Net CLI is not yet available."
    } else {
        Install-ChocolateyPackage $packageName $installerType $installerArgs $url
    }
} else {
    Write-Host "Microsoft .Net CLI is already installed on this machine."
}
