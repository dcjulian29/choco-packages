$packageName = "vscode"
$installerType = "EXE"
$installerArgs = "/SILENT /MERGETASKS=!runCode,addtopath,addcontextmenufolders"
$url = "https://az764295.vo.msecnd.net/stable/c212f0908f3d29933317bbc3233568fbca7944b1/VSCodeSetup-stable.exe"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

Install-ChocolateyPackage $packageName $installerType $installerArgs $url

if (Test-ProcessAdminRights) {
    Remove-Item "$($env:PUBLIC)\Desktop\Visual Studio Code.lnk" -Force
} else {
    Start-ChocolateyProcessAsAdmin "Remove-Item '$($env:PUBLIC)\Desktop\Visual Studio Code.lnk' -Force"
}
