$packageName = "syncthing"
$appDir = "$($env:SYSTEMDRIVE)\tools\apps\$($packageName)"

try {
    if (Test-Path $appDir)
    {
      Remove-Item "$($appDir)" -Recurse -Force
    }

    $location = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"

    $key = Get-Item $location
    if ($key.GetValue("syncthing", $null) -ne $null) {
        Remove-ItemProperty -Path $location -Name "syncthing"
    }

    Write-ChocolateySuccess $packageName
} catch {
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
