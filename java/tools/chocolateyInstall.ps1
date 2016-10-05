$packageName = "java"
$installerType = "exe"
$installerArgs = "/s REBOOT=Suppress WEB_JAVA=0"
$downloadPath = "$env:TEMP\$packageName"

$url = "http://javadl.oracle.com/webapps/download/AutoDL?BundleId=211997"
$url64 = "http://javadl.oracle.com/webapps/download/AutoDL?BundleId=211999"

Write-Output "Checking for and uninstalling previous versions of Java..."

. $PSScriptRoot\chocolateyUninstall.ps1

if (Test-Path $downloadPath) {
    Remove-Item -Path $downloadPath -Recurse -Force
}

New-Item -Type Directory -Path $downloadPath | Out-Null

Download-File $url "$downloadPath\$packageName.$installerType"

Invoke-ElevatedCommand "$downloadPath\$packageName.$installerType" -ArgumentList $installerArgs -Wait

$path = Join-Path $env:ProgramFiles "Java"

if ([System.IntPtr]::Size -ne 4) {
    Download-File $url64 "$downloadPath\$packageName-x64.$installerType"

    Invoke-ElevatedCommand "$downloadPath\$packageName-x64.$installerType" `
        -ArgumentList $installerArgs -Wait

    $path = Join-Path $env:ProgramW6432 "Java"
}

$path  = (Get-ChildItem -Path $path -Recurse -Include "bin").FullName `
    | Sort-Object | Select-Object -Last 1

$path = Split-Path -Path $path -Parent

Invoke-ElevatedExpression "[Environment]::SetEnvironmentVariable('JAVA_HOME','$path', 'Machine')"

Invoke-ElevatedScript -ScriptBlock {
    $appDir = "$($env:JAVA_HOME)\bin"
    $mklink = "cmd.exe /c mklink"
    $links = @(
    "java"
    "javaw"
    "javaws"
    )

    foreach ($link in $links) {
        if (Test-Path "${env:ChocolateyInstall}\bin\$link.exe") {
            (Get-Item "${env:ChocolateyInstall}\bin\$link.exe").Delete()
        }

        Invoke-Expression "$mklink '${env:ChocolateyInstall}\bin\$link.exe' '$appDir\$link.exe'"
    }
}
