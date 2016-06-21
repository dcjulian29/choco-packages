$packageName = "nugetexplorer"
$url = "https://julianscorner.com/downloads/NuGetPackageExplorer.zip"
$appDir = "$($env:SYSTEMDRIVE)\tools\apps\$($packageName)"
$downloadPath = "$env:TEMP\chocolatey\$packageName"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

if (Test-Path $appDir) {
    Write-Output "Removing previous version of package..."
    Remove-Item "$($appDir)" -Recurse -Force
}

if (Test-Path $downloadPath) {
    Remove-Item $downloadPath -Recurse -Force
}

New-Item -Type Directory -Path $downloadPath | Out-Null

Get-ChocolateyWebFile $packageName "$downloadPath\$packageName.zip" $url $url
Get-ChocolateyUnzip "$downloadPath\$packageName.zip" "$downloadPath" | Out-Null

if (-not (Test-Path $appDir)) {
    New-Item -Type Directory -Path $appDir | Out-Null
}

Get-ChildItem -Path "$downloadPath\NuGetPackageExplorer" | Copy-Item -Destination "$appDir"

$testType = (cmd /c assoc ".nupkg")
if ($testType -ne $null) {
    $fileType = $testType.Split("=")[1]
} else {
    $fileType = "Nuget.Package"
    $cmd = "cmd /c assoc .nupkg=$fileType"
    if (Test-ProcessAdminRights) {
        Invoke-Expression $cmd
    } else {
        Start-ChocolateyProcessAsAdmin $cmd
    }
}

$cmd = "cmd /c ftype $fileType=`"$($appDir)\NuGetPackageExplorer.exe`" %1"

if (Test-ProcessAdminRights) {
    Invoke-Expression $cmd
} else {
    Start-ChocolateyProcessAsAdmin $cmd
}
