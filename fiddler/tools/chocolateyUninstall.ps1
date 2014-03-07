$packageName = "__REPLACE__"
$packageWildCard = "*$($package)*";
$appDir = "$($env:ChocolateyInstall)\apps\$($packageName)"

try
{
    # For Portable-Apps
    if (Test-Path $appDir)
    {
      Remove-Item "$($appDir)" -Recurse -Force
    }
    
    # For Installed Applications ***TODO: Figure out how to elevate these two steps...
    $app = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -like $packageWildCard }
    if ($app -not $null) {
        $result = $app.Uninstall();
    }

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
