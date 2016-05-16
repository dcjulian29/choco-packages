$packageName = "dotnetcli"
$installerType = 'msi'
$installerArgs = '/passive'
$url = 'https://download.microsoft.com/download/4/6/1/46116DFF-29F9-4FF8-94BF-F9BE05BE263B/packages/DotNetCore.1.0.0.RC2-SDK.Preview1-x86.exe'
$url64 = 'https://download.microsoft.com/download/4/6/1/46116DFF-29F9-4FF8-94BF-F9BE05BE263B/packages/DotNetCore.1.0.0.RC2-SDK.Preview1-x64.exe'

$path = 'HKLM:\SOFTWARE\dotnet\Setup'
$version = "1.0.0"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

#if (Test-Path $Path) {
#    $installedversion =  (Get-ItemProperty -Path $Path -Name Version).Version
#} else {
#    $installedversion = "0.0.0"
#}

#if (-not ($installedversion.StartsWith($version))) {
    Install-ChocolateyPackage $packageName $installerType $installerArgs $url $url64
#} else {
#    Write-Host "Microsoft .Net CLI is already installed on this machine."
#}
