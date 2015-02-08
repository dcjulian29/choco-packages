$packageName = "tfsexplorer"
$installerType = "EXE"
$installerArgs = "/PASSIVE /NORESTART"
$url = "http://download.microsoft.com/download/4/3/4/43474B43-FC2D-462E-8DFF-F2B3D220E9D3/vs_teamExplorer.exe"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try
{
    Install-ChocolateyPackage $packageName $installerType $installerArgs $url -validExitCodes @(0, 3010)
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
