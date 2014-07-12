$packageName = "gpg"
$downloadPath = "$env:TEMP\chocolatey\$packageName"
$installerType = "EXE"
$installerArgs = "/S /C=$downloadPath\gpg4win.ini"
$url = "http://files.gpg4win.org/gpg4win-light-2.2.1.exe"
$toolDir = "$(Split-Path -parent $MyInvocation.MyCommand.Path)"

$install = @"
[gpg4win]
  inst_gpgol = false
  inst_gpgex = false
  inst_kleopatra = false
  inst_gpa = true
  inst_claws_mail = false
  inst_compendium = false
  inst_start_menu = false
  inst_desktop = false
  inst_quick_launch_bar = false
"@

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try
{
    if (-not (Test-Path $downloadPath)) {
        New-Item -Type Directory -Path $downloadPath | Out-Null
    }

    Set-Content -Value "$install" -Path $downloadPath\gpg4win.ini

    Install-ChocolateyPackage $packageName $installerType $installerArgs $url

    Start-ChocolateyProcessAsAdmin ". $toolDir\postInstall.ps1"

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
