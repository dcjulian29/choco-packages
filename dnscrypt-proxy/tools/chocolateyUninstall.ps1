$packageName = "dnscrypt-proxy"
$appDir = "$($env:SYSTEMDRIVE)\tools\apps\$($packageName)"

$service = Get-WmiObject -Class Win32_Service -Filter "Name='$packageName'"

if ($service) {
    if ($service.Started) {
        $service.StopService() | Out-Null
    }
    
    $service.Delete() | Out-Null
}

if (Test-Path $appDir)
{
  Remove-Item "$($appDir)" -Recurse -Force
}
