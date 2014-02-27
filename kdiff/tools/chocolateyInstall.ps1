$packageName = "kdiff"
$url = "http://sourceforge.net/projects/kdiff3/files/kdiff3/0.9.97/KDiff3-32bit-Setup_0.9.97.exe/download"
$url64 = "http://sourceforge.net/projects/kdiff3/files/kdiff3/0.9.97/KDiff3-64bit-Setup_0.9.97.exe/download"
$downloadPath = "$env:TEMP\chocolatey\$packageName"
$appDir = "$($env:ChocolateyInstall)\apps\$($packageName)"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
    $ErrorActionPreference = "Stop"
}

try
{
    if (Test-Path $appDir)
    {
        Write-Output "Removing previous version of package..."
        Remove-Item "$($appDir)" -Recurse -Force
    }

    mkdir $appDir | Out-Null
    
    if (-not (Test-Path $downloadPath))
    {
        mkdir $downloadPath | Out-Null
    }

    Get-ChocolateyWebFile $packageName "$downloadPath\$packageName.7z" $url $url64

    mkdir $downloadPath\$packageName | Out-Null

    Push-Location $downloadPath\$packageName

    & 'C:\Program Files\7-Zip\7z.exe' x $downloadPath\$packageName.7z

    Copy-Item -Path "`$_OUTDIR\*" -Destination ".\" -Recurse -Container
    Remove-Item -Path "`$_OUTDIR" -Recurse -Force
    Remove-Item -Path "`$APPDATA" -Recurse -Force
    Remove-Item -Path "`$PLUGINSDIR" -Recurse -Force

    Pop-Location

    Copy-Item -Path "$downloadPath\$packageName\*" -Destination "$appDir" -Recurse -Container

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
