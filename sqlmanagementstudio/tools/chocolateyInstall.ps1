$packageName = "sqlmanagementstudio"
$installerType = "EXE"
$installerArgs = "/QUIETSIMPLE /IACCEPTSQLSERVERLICENSETERMS /ACTION=install /FEATURES=Tools"
$url = "http://download.microsoft.com/download/E/A/E/EAE6F7FC-767A-4038-A954-49B8B05D04EB/SQLManagementStudio_x86_ENU.exe"
$url64 = "http://download.microsoft.com/download/E/A/E/EAE6F7FC-767A-4038-A954-49B8B05D04EB/SQLManagementStudio_x64_ENU.exe"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try
{
    Install-ChocolateyPackage $packageName $installerType $installerArgs $url $url64

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
