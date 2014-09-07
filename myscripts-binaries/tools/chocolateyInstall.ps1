$packageName = "myscripts-binaries"
$appDir = "$($env:SYSTEMDRIVE)\tools\binaries"
$version = "2014.9.7"
$repo = "scripts-binaries"
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

    if (-not ($($env:PATH).ToLowerInvariant().Contains("$($env:SYSTEMDRIVE)\tools\binaries".ToLowerInvariant()))) {
    
        $cmd = "cmd.exe /c 'setx /m PATH $($env:SYSTEMDRIVE)\tools\binaries;$($env:PATH)'"

        if (Test-ProcessAdminRights) {
            Invoke-Expression $cmd
        } else {
            Start-ChocolateyProcessAsAdmin $cmd
        }
    }

    Write-ChocolateySuccess $packageName
} catch {
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
