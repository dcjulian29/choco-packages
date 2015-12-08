$packageName = "vscode"
$installerType = "EXE"
$installerArgs = "/SILENT /NORESTART"
$url = "https://az764295.vo.msecnd.net/public/0.10.3/VSCodeSetup.exe"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

Install-ChocolateyPackage $packageName $installerType $installerArgs $url

if (Test-ProcessAdminRights) {
    Remove-Item "$($env:PUBLIC)\Desktop\Visual Studio Code.lnk" -Force
} else {
    Start-ChocolateyProcessAsAdmin "Remove-Item '$($env:PUBLIC)\Desktop\Visual Studio Code.lnk' -Force"
}
