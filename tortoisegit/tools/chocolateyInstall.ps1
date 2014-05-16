$packageName = "tortoisegit"
$installerType = "MSI"
$installerArgs = "/quiet /passive /norestart"
$url = "http://download.tortoisegit.org/tgit/1.8.8.0/TortoiseGit-1.8.8.0-32bit.msi"
$url64 = "http://download.tortoisegit.org/tgit/1.8.8.0/TortoiseGit-1.8.8.0-64bit.msi"

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
