$packageName = "smartgit"
$downloadPath = "$env:TEMP\chocolatey\$packageName"
$appDir = "$($env:SYSTEMDRIVE)\tools\apps\$($packageName)"
$installerType = "EXE"
$installerArgs = '/sp- /silent /norestart'
$version = '8_0_0'

$url = 'http://www.syntevo.com/static/smart/download/smartgit/smartgit-win32-setup-nojre-{0}.zip' -f $version

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

if (Test-Path $downloadPath) {
    Remove-Item -Path $downloadPath -Force | Out-Null
}

New-Item -Type Directory -Path $downloadPath | Out-Null

Get-ChocolateyWebFile $packageName "$downloadPath\$packageName.zip" $url
Get-ChocolateyUnzip "$downloadPath\$packageName.zip" "$downloadPath\"

$installFileLocation = [IO.Path]::Combine($downloadPath, "setup-{0}.exe" -f $version)

Install-ChocolateyInstallPackage $packageName $installerType $installerArgs $installFileLocation

if (Test-Path "C:\Program Files (x86)\Java") {
    $java = "C:\Program Files (x86)\Java"

    $java  = (Get-ChildItem -Path $java -Recurse -Include "bin").FullName `
        | Sort-Object | Select-Object -Last 1

    $java = Split-Path -Path $java -Parent

    if (Test-ProcessAdminRights) {
        [Environment]::SetEnvironmentVariable('SMARTGIT_JAVA_HOME',"$java", 'Machine')
    } else {
        Start-ChocolateyProcessAsAdmin `
            "[Environment]::SetEnvironmentVariable('SMARTGIT_JAVA_HOME','$java', 'Machine')"
    }
}
