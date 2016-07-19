$packageName = "vscode"
$installerType = "EXE"
$installerArgs = "/SILENT /MERGETASKS=!runCode,addtopath,addcontextmenufolders"
$url = "https://az764295.vo.msecnd.net/stable/e6b4afa53e9c0f54edef1673de9001e9f0f547ae/VSCodeSetup-stable.exe"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

Install-ChocolateyPackage $packageName $installerType $installerArgs $url

if (Test-Path "$($env:PUBLIC)\Desktop\Visual Studio Code.lnk") {
    if (Test-ProcessAdminRights) {
        Remove-Item "$($env:PUBLIC)\Desktop\Visual Studio Code.lnk" -Force
    } else {
        Start-ChocolateyProcessAsAdmin "Remove-Item '$($env:PUBLIC)\Desktop\Visual Studio Code.lnk' -Force"
    }
}

Write-Output "Install some VS Code extensions..."

$code = "$env:PF32\Microsoft VS Code\bin\code.cmd"

Start-Process -FilePath $code -ArgumentList "--install-extension ms-vscode.csharp" -NoNewWindow -Wait
Start-Process -FilePath $code -ArgumentList "--install-extension donjayamanne.python" -NoNewWindow -Wait
Start-Process -FilePath $code -ArgumentList "--install-extension msjsdiag.debugger-for-chrome" -NoNewWindow -Wait
Start-Process -FilePath $code -ArgumentList "--install-extension samverschueren.yo" -NoNewWindow -Wait
Start-Process -FilePath $code -ArgumentList "--install-extension rprouse.theme-obsidian" -NoNewWindow -Wait
Start-Process -FilePath $code -ArgumentList "--install-extension PeterJausovec.vscode-docker" -NoNewWindow -Wait
Start-Process -FilePath $code -ArgumentList "--install-extension Pendrica.Chef" -NoNewWindow -Wait
Start-Process -FilePath $code -ArgumentList "--install-extension cake-build.cake-vscode" -NoNewWindow -Wait

