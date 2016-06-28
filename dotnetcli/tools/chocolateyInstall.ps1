$packageName = "dotnetcli"
$installerType = 'exe'
$installerArgs = '/passive'
$url = 'https://download.microsoft.com/download/A/3/8/A38489F3-9777-41DD-83F8-2CBDFAB2520C/packages/DotNetCore.1.0.0-SDK.Preview2-x86.exe'
$url64 = 'https://download.microsoft.com/download/A/3/8/A38489F3-9777-41DD-83F8-2CBDFAB2520C/packages/DotNetCore.1.0.0-SDK.Preview2-x64.exe'

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
