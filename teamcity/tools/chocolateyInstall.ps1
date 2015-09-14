$packageName = "teamcity"
$installerType = "EXE"
$installerArgs = "/S"
$url = "https://download.jetbrains.com/teamcity/TeamCity-9.1.1.exe"
$appDir = "$($env:SYSTEMDRIVE)\TeamCity"
$upgrade = $false

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

if (Test-Path $appDir) {
    $upgrade = $true
    Stop-Service -Name TCBuildAgent -Force
    Stop-Service -Name TeamCity -Force
}

Install-ChocolateyPackage $packageName $installerType $installerArgs $url

while (! ((Get-Process -Name "TeamCity*" -ErrorAction SilentlyContinue).Id) -eq "") {
      Write-Host "Sleeping for another 10 seconds waiting for extraction to complete..."
      Start-sleep -Seconds 10
}

if (-not $upgrade) {
    & $appdir\bin\teamcity-server.bat service install /runAsSystem

    Push-Location $appdir\buildAgent\bin
    & ./service.install.bat
    Pop-Location

    Copy-Item "$appdir\conf\server-standard.xml" "$appdir\conf\server.xml"

    (Get-Content "$appdir\conf\server.xml") `
        -replace 'Connector port="8111"', 'Connector port="80"' `
        | Set-Content "$appdir\conf\server.xml"

    $datadir = "$appdir\.data"

    $cmd = "[Environment]::SetEnvironmentVariable('TEAMCITY_DATA_PATH','$datadir', 'Machine')"

    if (Test-ProcessAdminRights) {
        Invoke-Expression $cmd
    } else {
        Start-ChocolateyProcessAsAdmin $cmd
    }

    $env:TEAMCITY_DATA_PATH = $datadir

    netsh advfirewall firewall add rule name="Allow HTTP Inbound" dir=in action=allow protocol=TCP localport=80
}

net start TeamCity

if (-not $upgrade) {
    Copy-Item "$appdir\buildAgent\conf\buildAgent.dist.properties" "$appdir\buildAgent\conf\buildAgent.properties"

    (Get-Content "$appdir\buildAgent\conf\buildAgent.properties") `
        -replace 'serverUrl=http://localhost:8111', 'serverUrl=http://localhost' `
        | Set-Content "$appdir\buildAgent\conf\buildAgent.properties"

    (Get-Content "$appdir\buildAgent\conf\buildAgent.properties") `
        -replace "name=localhost", "name=${env:COMPUTERNAME}" `
        | Set-Content "$appdir\buildAgent\conf\buildAgent.properties"
}

net start TCBuildAgent
