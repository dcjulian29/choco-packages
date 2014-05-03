$packageName = "crashplan"
$installerType = "EXE"
$installerArgs = "/quiet /norestart"
$url = "http://download2.us.code42.com/installs/win/install/CrashPlan/jre/CrashPlan_3.6.3_Win.exe"
$url64 = "http://download2.us.code42.com/installs/win/install/CrashPlan/jre/CrashPlan-x64_3.6.3_Win.exe"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
    $ErrorActionPreference = "Stop"
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
