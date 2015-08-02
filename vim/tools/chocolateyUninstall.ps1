$packageName = "vim"
$appDir = "$($env:SYSTEMDRIVE)\tools\apps\$($packageName)"
$toolDir = "$(Split-Path -parent $MyInvocation.MyCommand.Path)"

if (Test-Path $appDir)
{
  Remove-Item "$($appDir)" -Recurse -Force
}

if (Test-Path "${env:USERPROFILE}\_vimrc") {
    Remove-Item "${env:USERPROFILE}\_vimrc" -Force
}

if (Test-Path "$env:ProgramFiles\Git") {
    $git = "$env:ProgramFiles\Git\bin\git.exe"
}

if (Test-Path "${env:ProgramFiles(x86)}\Git") {
    $git = "${env:ProgramFiles(x86)}\Git\bin\git.exe"
}

if (Test-Path $git) {
    & $git config --unset --global core.editor
}

if (Test-ProcessAdminRights) {
    . $toolDir\postUninstall.ps1
} else {
    Start-ChocolateyProcessAsAdmin ". $toolDir\postUninstall.ps1"
}
