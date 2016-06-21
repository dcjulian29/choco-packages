$packageName = "dnscrypt-proxy"
$version = "1.6.1"
$url = "https://download.dnscrypt.org/dnscrypt-proxy/dnscrypt-proxy-win32-full-$version.zip"

$downloadPath = "$env:TEMP\chocolatey\$packageName"
$appDir = "$($env:SYSTEMDRIVE)\tools\apps\$($packageName)"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

if (-not (Test-Path $downloadPath)) {
    New-Item -Type Directory -Path $downloadPath | Out-Null
}

Get-ChocolateyWebFile $packageName "$downloadPath\$packageName.zip" $url $url
Get-ChocolateyUnzip "$downloadPath\$packageName.zip" "$downloadPath\"

$cmd = {
    $service = Get-WmiObject -Class Win32_Service -Filter "Name=`'dnscrypt-proxy`'"

    if ($service) {
        if ($service.Started) {
            $service.StopService() | Out-Null
        }
        
        $service.Delete() | Out-Null
    }
}

if (Test-ProcessAdminRights) {
    Invoke-Command -ScriptBlock $cmd
} else {
    Start-ChocolateyProcessAsAdmin $cmd
}

if (Test-Path $appDir) {
    Write-Output "Removing previous version of package..."
    Remove-Item -Path $appDir -Recurse -Force
}

New-Item -Type Directory -Path $appDir | Out-Null

Copy-Item -Path "$downloadPath\$($packageName)-win32\*" -Destination "$appDir\"

# Test to make sure we can get to DNS Proxy before changing DNS settings.
& "$appdir\dnscrypt-proxy.exe" -R dnscrypt.org-fr --test=0

if ($lastexitcode -ne 0) {
    Write-Error "Cannot successfully connect to DNS Proxy..."
} else {
    $cmd = {
        param($appdir)

        $wmi = Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter "IPEnabled = `'True`'"

        $DNSServers = $wmi.DNSServerSearchOrder

        if ($DNSServers.Count -gt 0) {
            $nonProxyDns = $DNSServers[0]

            $proxyDns = @("127.0.0.1", $nonProxyDns)

            $wmi.SetDNSServerSearchOrder($proxyDns) | Out-Null
        }
    
        & "$appdir\dnscrypt-proxy" -R dnscrypt.org-fr --install
    }

    if (Test-ProcessAdminRights) {
        Invoke-Command -ScriptBlock $cmd -ArgumentList $appDir
    } else {
        #####FAIL
        Start-ChocolateyProcessAsAdmin "Invoke-Command -ScriptBlock $cmd -ArgumentList "$appDir""
    }
}
