$packageName = "vscode"
$installerType = "EXE"
$installerArgs = "/SILENT /NORESTART"
$url = "https://az764295.vo.msecnd.net/stable/5b5f4db87c10345b9d5c8d0bed745bcad4533135/VSCodeSetup-stable.exe"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

Install-ChocolateyPackage $packageName $installerType $installerArgs $url

if (Test-ProcessAdminRights) {
    Remove-Item "$($env:PUBLIC)\Desktop\Visual Studio Code.lnk" -Force
} else {
    Start-ChocolateyProcessAsAdmin "Remove-Item '$($env:PUBLIC)\Desktop\Visual Studio Code.lnk' -Force"
}
