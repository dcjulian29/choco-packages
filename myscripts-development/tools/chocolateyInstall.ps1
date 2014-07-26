$packageName = "myscripts-development"
$appDir = "$($env:SYSTEMDRIVE)\tools\development"
$url = "https://github.com/dcjulian29/dev-scripts/archive"
$repo = "dev-scripts-master"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try {
    if (Test-Path $appDir)
    {
        Write-Output "Removing previous version of package..."
        Remove-Item "$($appDir)\*" -Recurse -Force
    }

    if (-not (Test-Path $appDir))
    {
        New-Item -Type Directory -Path $appDir | Out-Null
    }

    (New-Object System.Net.WebClient).DownloadFile("$url/master.zip", "$env:TEMP\master.zip")
    $shell = New-Object -com Shell.Application
    $shell.namespace($env:TEMP).CopyHere($shell.namespace("$env:TEMP\master.zip").items(), 0x10) 
    Copy-Item -Path "$($env:TEMP)\$repo\*" -Destination $appdir -Recurse -Force
    Remove-Item -Path "$($env:TEMP)\$repo" -Recurse -Force
    Remove-Item -Path "$($env:TEMP)\master.zip" -Force

    Write-ChocolateySuccess $packageName
} catch {
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
