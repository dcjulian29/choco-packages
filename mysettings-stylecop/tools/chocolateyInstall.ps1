$packageName = "mysettings-stylecop"

if (Test-Path "${env:ProgramFiles(x86)}\StyleCop 4.7") {
    $appDir = "${env:ProgramFiles(x86)}\StyleCop 4.7"
}

if (Test-Path "$($env:ProgramFiles)\StyleCop 4.7") {
    $appDir = "$($env:ProgramFiles)\StyleCop 4.7"
}

$toolDir = "$(Split-Path -parent $MyInvocation.MyCommand.Path)"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try {
    if (Test-Path $appDir) {
        if (Test-Path "$($appDir)\Settings.StyleCop") {
            Remove-Item "$($appDir)\Settings.StyleCop" -Force
        }
    }

    Start-ChocolateyProcessAsAdmin "{Copy-Item -Path ""$toolDir\Settings.StyleCop"" -Destination ""$appDir\Settings.StyleCop"" -Force}"

    Write-ChocolateySuccess $packageName
} catch {
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
