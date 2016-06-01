$packageName = "vscode"
$installerType = "EXE"
$installerArgs = "/SILENT /MERGETASKS=!runCode,addtopath,addcontextmenufolders"
$url = "https://az764295.vo.msecnd.net/stable/def9e32467ad6e4f48787d38caf190acbfee5880/VSCodeSetup-stable.exe"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

Install-ChocolateyPackage $packageName $installerType $installerArgs $url

if (Test-ProcessAdminRights) {
    Remove-Item "$($env:PUBLIC)\Desktop\Visual Studio Code.lnk" -Force
} else {
    Start-ChocolateyProcessAsAdmin "Remove-Item '$($env:PUBLIC)\Desktop\Visual Studio Code.lnk' -Force"
}
