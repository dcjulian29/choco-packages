$packageName = "tortoisegit"
$installerType = "MSI"
$installerArgs = "/quiet /passive /norestart"
$version = "1.8.10.0"
$url = "http://download.tortoisegit.org/tgit/$version/TortoiseGit-$version-32bit.msi"
$url64 = "http://download.tortoisegit.org/tgit/$version/TortoiseGit-$version-64bit.msi"

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
