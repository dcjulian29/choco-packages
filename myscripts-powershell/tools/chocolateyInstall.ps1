$packageName = "myscripts-powershell"
$appDir = "$($env:SYSTEMDRIVE)\tools\powershell"
$version = "2015.3.27"
$repo = "scripts-powershell"
$url = "https://github.com/dcjulian29/$repo/archive/$version.zip"
$toolDir = "$(Split-Path -parent $MyInvocation.MyCommand.Path)"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try {
    if (Test-Path $appDir\Modules) {
        cmd /c rmdir "$appdir\Modules"
    }

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

    [System.Reflection.Assembly]::LoadWithPartialName("System.IO.Compression.FileSystem") | Out-Null
    [System.IO.Compression.ZipFile]::ExtractToDirectory("$env:TEMP\$file.zip", $env:TEMP)
    
    Copy-Item -Path "$($env:TEMP)\$file\*" -Destination $appdir -Recurse -Force

    Remove-Item -Path "$($env:TEMP)\$file" -Recurse -Force
    Remove-Item -Path "$($env:TEMP)\$file.zip" -Force

    $cmd = ". $toolDir\postInstall.bat"

    if (Test-ProcessAdminRights) {
        Invoke-Expression $cmd
    } else {
        Start-ChocolateyProcessAsAdmin $cmd
    }

    Write-ChocolateySuccess $packageName
} catch {
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
