$packageName = "devenv"
$packages = @(
    "mydev-powershell",
    "mydev-scm",
    "mydev-tools",
    "mydev-nodejs",
    "mydev-python",
    "mydev-database",
    "mydev-visualstudio",
    "mydev-buildtools"
)
$toolDir = "$(Split-Path -parent $MyInvocation.MyCommand.Path)"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

$devvmpackage = (Get-ChildItem "$($env:ChocolateyInstall)\lib" `
    | Select-Object basename).basename `
    | Where-Object { $_.StartsWith($packageName) }

if ($devvmpackage.Count -gt 1) {
    Write-Warning "This package has already been installed, attempting to upgrade any dependent packages..."
    foreach ($package in $packages) {
        choco.exe -y upgrade $package
    }
} else {
    Write-Warning "This is the first time this package is install so assume no other packages have been installed..."
    foreach ($package in $packages) {
        choco.exe -y install $package
    }
}

if (-not (Test-Path $env:SYSTEMDRIVE\home\projects))
{
    New-Item -Type Directory -Path $env:SYSTEMDRIVE\home\projects | Out-Null
}

Import-Module "${env:USERPROFILE}\Documents\WindowsPowerShell\Modules\go\go.psm1"
Set-Alias -Name go -Value gd

go -Key "projects" -delete
go -Key "projects" -SelectedPath "${env:SYSTEMDRIVE}\home\projects" -add
go -Key "etc" -delete
go -Key "etc" -SelectedPath "${env:SYSTEMDRIVE}\etc" -add
go -Key "documents" -delete
go -Key "documents" -SelectedPath "${env:USERPROFILE}\documents" -add
go -Key "docs" -delete
go -Key "docs" -SelectedPath "${env:USERPROFILE}\documents" -add
go -Key "pictures" -delete
go -Key "pictures" -SelectedPath "${env:USERPROFILE}\pictures" -add
go -Key "pics" -delete
go -Key "pics" -SelectedPath "${env:USERPROFILE}\pictures" -add
go -Key "videos" -delete
go -Key "videos" -SelectedPath "${env:USERPROFILE}\videos" -add
go -Key "desktop" -delete
go -Key "desktop" -SelectedPath "${env:USERPROFILE}\desktop" -add
go -Key "downloads" -delete
go -Key "downloads" -SelectedPath "$env:USERPROFILE\downloads" -add

$cmd = ". $toolDir\postInstall.bat"

if (Test-ProcessAdminRights) {
    Invoke-Expression $cmd
} else {
    Start-ChocolateyProcessAsAdmin $cmd
}
