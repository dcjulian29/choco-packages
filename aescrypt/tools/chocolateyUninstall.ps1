$packageName = "aescrypt"
$appDir = "$($env:SYSTEMDRIVE)\tools\apps\$($packageName)"

try {
    if (Test-Path $appDir)
    {
        Remove-Item "$($appDir)" -Recurse -Force
    }

    if (Test-Path "$env:ChocolateyInstall\bin\aescrypt.exe") {
        Remove-Item "$env:ChocolateyInstall\bin\aescrypt.exe" -Force
    }

    Write-ChocolateySuccess $packageName
} catch {
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
