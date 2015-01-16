$packageName = "teamcity"
$installerType = "EXE"
$installerArgs = "/S"
$url = "http://download-cf.jetbrains.com/teamcity/TeamCity-9.0.1.exe"
$appDir = "$($env:SYSTEMDRIVE)\TeamCity"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try {
    Install-ChocolateyPackage $packageName $installerType $installerArgs $url

    While (! ((Get-Process -Name "TeamCity*" -ErrorAction SilentlyContinue).Id) -eq "") {
          Write-Host "Sleeping for another 10 seconds waiting for extraction to complete..."
          Start-sleep -Seconds 10
    }

    & $appdir\bin\teamcity-server.bat service install /runAsSystem

    Push-Location $appdir\buildAgent\bin
    & ./service.install.bat
    Pop-Location

    Copy-Item "$appdir\conf\server-standard.xml" "$appdir\conf\server.xml"

    (Get-Content "$appdir\conf\server.xml") `
        -replace 'Connector port="8111"', 'Connector port="80"' `
        | Set-Content "$appdir\conf\server.xml"

    $datadir = "$appdir\TeamCity\.data"

    $cmd = "[Environment]::SetEnvironmentVariable('TEAMCITY_DATA_PATH','$datadir', 'Machine')"

    if (Test-ProcessAdminRights) {
        Invoke-Expression $cmd
    } else {
        Start-ChocolateyProcessAsAdmin $cmd
    }

    $env:TEAMCITY_DATA_PATH = $datadir

    net start TeamCity

    Copy-Item "$appdir\buildAgent\conf\buildAgent.dist.properties" "$appdir\buildAgent\conf\buildAgent.properties"

    (Get-Content "$appdir\buildAgent\conf\buildAgent.properties") `
        -replace 'serverUrl=http://localhost:8111', 'serverUrl=http://localhost' `
        | Set-Content "$appdir\buildAgent\conf\buildAgent.properties"

    (Get-Content "$appdir\buildAgent\conf\buildAgent.properties") `
        -replace 'name=localhost', "name=${env:COMPUTERNAME}" `
        | Set-Content "$appdir\buildAgent\conf\buildAgent.properties"

    net start TCBuildAgent

    netsh advfirewall firewall add rule name="Allow HTTP Inbound" dir=in action=allow protocol=TCP localport=80

    Write-ChocolateySuccess $packageName
} catch {
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
