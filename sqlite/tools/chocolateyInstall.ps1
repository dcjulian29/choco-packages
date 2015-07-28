$packageName = "sqlite"
$sqliteShell = "http://www.sqlite.org/2015/sqlite-shell-win32-x86-3081100.zip"
$sqliteAnalyzer = "https://www.sqlite.org/2015/sqlite-analyzer-win32-x86-3081100.zip"

$downloadPath = "$($env:TEMP)\chocolatey\$($packageName)"
$appDir = "$($env:SYSTEMDRIVE)\tools\apps\$($packageName)"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try {
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

    Get-ChocolateyWebFile $packageName "$downloadPath\sqliteShell.zip" $sqliteShell
    Get-ChocolateyWebFile $packageName "$downloadPath\sqliteAnalyzer.zip" $sqliteAnalyzer

    Get-ChocolateyUnzip "$downloadPath\sqliteShell.zip" "$downloadPath"
    Get-ChocolateyUnzip "$downloadPath\sqliteAnalyzer.zip" "$downloadPath"

    Copy-Item -Path "$($downloadPath)\*.exe" -Destination "$appDir" -Recurse

    $shimgen = "$env:ChocolateyInstall\chocolateyinstall\tools\shimgen.exe"

    if (Test-ProcessAdminRights) {
        cmd /c mklink "$env:ChocolateyInstall\bin\sqlite3.exe" "$appDir\sqlite3.exe"
    } else {
        Start-ChocolateyProcessAsAdmin "cmd /c mklink '$env:ChocolateyInstall\bin\sqlite3.exe' '$appDir\sqlite3.exe'"
    }

    if (Test-ProcessAdminRights) {
        cmd /c mklink /J "$env:ChocolateyInstall\bin\sqlite3_analyzer.exe" "$appDir\sqlite3_analyzer.exe"
    } else {
        Start-ChocolateyProcessAsAdmin "cmd /c mklink /J '$env:ChocolateyInstall\bin\sqlite3_analyzer.exe' '$appDir\sqlite3_analyzer.exe'"
    }

    Write-ChocolateySuccess $packageName
} catch {
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
