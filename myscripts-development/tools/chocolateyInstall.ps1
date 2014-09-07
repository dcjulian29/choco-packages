$packageName = "myscripts-development"
$appDir = "$($env:SYSTEMDRIVE)\tools\development"
$version = "2014.9.7"
$repo = "scripts-development"
$url = "https://github.com/dcjulian29/$repo/archive/$version.zip"

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

    $file = "$repo-$version"

    (New-Object System.Net.WebClient).DownloadFile("$url", "$env:TEMP\$file.zip")

    $shell = New-Object -com Shell.Application
    $shell.namespace($env:TEMP).CopyHere($shell.namespace("$env:TEMP\$file.zip").items(), 0x10)
    
    Copy-Item -Path "$($env:TEMP)\$file\*" -Destination $appdir -Recurse -Force

    Remove-Item -Path "$($env:TEMP)\$file" -Recurse -Force
    Remove-Item -Path "$($env:TEMP)\$file.zip" -Force


    Write-ChocolateySuccess $packageName
} catch {
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
