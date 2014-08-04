$packageName = "scriptcs"
$release = "0.10.2"
$downloadPath = "$($env:TEMP)\chocolatey\$($packageName)"
$appDir = "$env:SYSTEMDRIVE\tools\apps\$packageName"
$url = "https://codeload.github.com/scriptcs/scriptcs/zip/v$release"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try
{
    if (Test-Path $appDir)
    {
      Write-Output "Removing previous version of package..."
      Remove-Item "$($appDir)\*" -Recurse -Force
    }

    New-Item -Type Directory -Path $appDir | Out-Null

    if (-not (Test-Path $downloadPath))
    {
        New-Item -Type Directory -Path $downloadPath | Out-Null
    }

    Get-ChocolateyWebFile $packageName "$downloadPath\$packageName.zip" $url
    Get-ChocolateyUnzip "$downloadPath\$packageName.zip" "$downloadPath\"

    Push-Location "$downloadPath\$packageName-$release"

    cmd /c "$downloadPath\$packageName-$release\build.cmd"

    Copy-Item -Path "artifacts\Release\bin\*.dll" -Destination "$appDir"
    Copy-Item -Path "artifacts\Release\bin\*.dll.config" -Destination "$appDir"
    Copy-Item -Path "artifacts\Release\bin\*.exe" -Destination "$appDir"
    Copy-Item -Path "artifacts\Release\bin\*.exe.config" -Destination "$appDir"

    Pop-Location

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
