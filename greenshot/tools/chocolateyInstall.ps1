$packageName = "greenshot"
$installerType = "EXE"
$installerArgs = "/SILENT"
$url = "http://sourceforge.net/projects/greenshot/files/Greenshot/Greenshot%201.2/Greenshot-INSTALLER-1.2.6.7-RELEASE.exe/download"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

if (Get-Process "Greenshot" -ErrorAction SilentlyContinue) {
    Stop-Process -ProcessName "Greenshot"
}

if (-not (Test-Path "HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v3.5")) {
    $dism = "$env:WinDir\sysnative\dism.exe"
    $args = "/Online /NoRestart /Enable-Feature /FeatureName:NetFx3"

    if (Test-ProcessAdminRights) {
        cmd /c "$dism $args"
    } else {
        Start-ChocolateyProcessAsAdmin "cmd /c `"$dism $args`""
    }
} else {
    Write-Verbose "Microsoft .Net 3.5 Framework is already installed on this system..."
} 

Install-ChocolateyPackage $packageName $installerType $installerArgs $url

Write-ChocolateySuccess $packageName
