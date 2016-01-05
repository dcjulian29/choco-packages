$packageName = "ldapbrowser"
$installerType = "MSI"
$installerArgs = "/quiet /norestart"
$url = "http://softerra-downloads.com/ldapadmin/ldapbrowser-4.5.13724.0-x86-eng.msi"
$url64 = "http://softerra-downloads.com/ldapadmin/ldapbrowser-4.5.13724.0-x64-eng.msi"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

Install-ChocolateyPackage $packageName $installerType $installerArgs $url $url64

if (Test-Path "$($env:PUBLIC)\Desktop\Softerra LDAP Browser 4.5 (64-bit).lnk") {
    Remove-Item "$($env:PUBLIC)\Desktop\Softerra LDAP Browser 4.5 (64-bit).lnk" -Force
}


if (Test-Path "$($env:USERPROFILE)\Desktop\Softerra LDAP Browser 4.5 (64-bit).lnk") {
    Remove-Item "$($env:USERPROFILE)\Desktop\Softerra LDAP Browser 4.5 (64-bit).lnk" -Force
}
