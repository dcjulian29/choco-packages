$packageName = "smartgit"
$downloadPath = "$env:TEMP\chocolatey\$packageName"
$appDir = "$($env:SYSTEMDRIVE)\tools\apps\$($packageName)"
$url = "http://www.syntevo.com/download/smartgit/smartgit-portable-6_5_4.7z"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try
{
    if (-not (Test-Path $downloadPath)) {
        New-Item -Type Directory -Path $downloadPath | Out-Null
    }

    Get-ChocolateyWebFile $packageName "$downloadPath\$packageName.7z" $url
    Get-ChocolateyUnzip "$downloadPath\$packageName.7z" "$downloadPath\"

    if (Test-Path $appDir) {
        Move-Item -Path "$appDir\.settings" -Destination "$downloadPath\.settings"
        Remove-Item "$($appDir)" -Recurse -Force
    }

    New-Item -Type Directory -Path $appDir | Out-Null
    New-Item -Type Directory -Path "$appDir\bin" | Out-Null
    New-Item -Type Directory -Path "$appDir\lib" | Out-Null
    New-Item -Type Directory -Path "$appDir\licenses" | Out-Null

    Copy-Item -Path "$downloadPath\SmartGit\bin\*" -Destination "$appDir\bin" -Recurse -Container
    Copy-Item -Path "$downloadPath\SmartGit\lib\*" -Destination "$appDir\lib" -Recurse -Container
    Copy-Item -Path "$downloadPath\SmartGit\licenses\*" -Destination "$appDir\licenses" -Recurse -Container

    if (Test-Path "$downloadPath\.settings") {
        Move-Item -Path "$downloadPath\.settings" -Destination "$appDir\.settings"
    }

    if (Test-Path "C:\Program Files (x86)\Java\jre7") {
        $java = "C:\Program Files (x86)\Java\jre7"

        if (Test-ProcessAdminRights) {
            [Environment]::SetEnvironmentVariable('SMARTGIT_JAVA_HOME',"$java", 'Machine')
        } else {
            Start-ChocolateyProcessAsAdmin `
                "[Environment]::SetEnvironmentVariable('SMARTGIT_JAVA_HOME','$java', 'Machine')"
        }
    }

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
