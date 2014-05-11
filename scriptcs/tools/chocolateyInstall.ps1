$packageName = "scriptcs"
$release = "0.9"
$toolDir = "$(Split-Path -parent $MyInvocation.MyCommand.Path)"
$appDir = "$env:ChocolateyInstall\apps\$packageName"
$url = "https://github.com/scriptcs/scriptcs/archive/v$release.zip"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
    $ErrorActionPreference = "Stop"
}

try
{
    if (Test-Path $appDir)
    {
      Write-Output "Removing previous version of package..."
      Remove-Item "$($appDir)\*" -Recurse -Force
    }

    if ($(Test-Path "$toolDir\$packageName-$release")) {
        Remove-Item "$toolDir\$packageName-$release" -Recurse -Force
    }

    Get-ChocolateyWebFile $packageName "$toolDir\v$release.zip" $url
    Get-ChocolateyUnzip "$toolDir\v$release.zip" "$toolDir\"

    Push-Location "$toolDir\$packageName-$release"

    cmd /c "$toolDir\$packageName-$release\build.cmd"

    if (-not $(Test-Path $appDir)) {
        New-Item $appDir -ItemType Directory
    }

    Copy-Item -Path "artifacts\Release\bin\*.dll" -Destination "$appDir"
    Copy-Item -Path "artifacts\Release\bin\*.exe" -Destination "$appDir"
    Copy-Item -Path "artifacts\Release\bin\*.exe.config" -Destination "$appDir"

    Pop-Location

    Remove-Item "$toolDir\$packageName-$release\" -Recurse -Force
    Remove-Item "$toolDir\v$release.zip" -Force
    
    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
