$packageName = "dnx"
$url = "https://raw.githubusercontent.com/aspnet/Home/v1.0.0-rc1-final/dnvminstall.ps1"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

& {Invoke-Expression ((New-Object Net.WebClient).DownloadString($url))}

. ${env:USERPROFILE}\.dnx\bin\dnvm.ps1 install 1.0.0-rc1-update1 -a x64 -r coreclr -f -p
