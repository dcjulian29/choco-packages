$packageName = "mysettings-stylecop"
$toolDir = "$(Split-Path -parent $MyInvocation.MyCommand.Path)"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try {
    if (Test-Path "${env:ProgramFiles(x86)}\StyleCop 4.7") {
        $appDir = "${env:ProgramFiles(x86)}\StyleCop 4.7"
    }

    if (Test-Path "$($env:ProgramFiles)\StyleCop 4.7") {
        $appDir = "$($env:ProgramFiles)\StyleCop 4.7"
    }

    if (Test-Path "$($appDir)\Settings.StyleCop") {
        $cmd = "Remove-Item '$($appDir)\Settings.StyleCop' -Force"

        Start-ChocolateyProcessAsAdmin $cmd
    }

    $cmd = "Copy-Item -Path '$($toolDir)\Settings.StyleCop' -Destination '$appDir\'"

    Start-ChocolateyProcessAsAdmin $cmd

    Write-ChocolateySuccess $packageName
} catch {
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
