$packageName = "mongodb"
$version = "2.6.5"
$url = "https://fastdl.mongodb.org/win32/mongodb-win32-i386-$version.zip"
$url64 = "https://fastdl.mongodb.org/win32/mongodb-win32-x86_64-2008plus-$version.zip"

$appDir = "$($env:SYSTEMDRIVE)\tools\apps\$($packageName)"
$downloadPath = "$env:TEMP\chocolatey\$packageName"
$dataDir = "$($env:SYSTEMDRIVE)\data\mongo"
$sn = "MongoDB"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try
{
    if (Get-Service | Where-Object { $_.Name -eq $sn }) {
        $cmd = "net.exe stop $sn;sc.exe delete $sn"
        Start-ChocolateyProcessAsAdmin $cmd
    }

    if (Test-Path $appDir)
    {
        Write-Output "Removing previous version of package..."
        Remove-Item "$($appDir)" -Recurse -Force
    }

    New-Item -Type Directory -Path $appDir | Out-Null
    
    if (-not (Test-Path $downloadPath))
    {
        New-Item -Type Directory -Path $downloadPath | Out-Null
    }

    Get-ChocolateyWebFile $packageName "$downloadPath\$packageName.zip" $url $url64
    Get-ChocolateyUnzip "$downloadPath\$packageName.zip" "$downloadPath\"

    $extractPath = $(Get-ChildItem -Directory -Path $downloadPath | Select-Object -First 1).Name

    Copy-Item -Path "$($downloadPath)\$($extractPath)\bin\*" -Destination "$appDir" -Recurse
    Copy-Item -Path "$($downloadPath)\$($extractPath)\GNU-AGPL-3.0" -Destination "$appDir"

    if (-not (Test-Path $dataDir))
    {
        New-Item -Type Directory -Path $dataDir | Out-Null
    }

    $config = "$($appDir)\mongod.cfg"

    Set-Content -Path $config -Encoding Ascii -Value "logpath=$dataDir\mongod.log"
    Add-Content -Path $config -Encoding Ascii -Value "logappend=true"
    Add-Content -Path $config -Encoding Ascii -Value "dbpath=$dataDir"
    Add-Content -Path $config -Encoding Ascii -Value "directoryperdb=true"

    $cmd = "& $appDir\mongod.exe --config ""$appDir\mongod.cfg"" --install"
    Start-ChocolateyProcessAsAdmin $cmd

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
