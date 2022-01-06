$location = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
$key = Get-Item $location

if ($null -ne $key.GetValue("syncthing", $null)) {
  Remove-ItemProperty -Path $location -Name "syncthing" -Force
}

New-ItemProperty -Path $location -Name "syncthing" `
    -Value "$env:ChocolateyInstall\bin\syncthing.exe -no-console -no-browser"

New-NetFirewallRule -DisplayName 'Syncthing-Inbound-TCP' -Profile Domain -Direction Inbound `
    -Action Allow -Protocol TCP -LocalPort 22000
New-NetFirewallRule -DisplayName 'Syncthing-Inbound-UDP' -Profile Domain -Direction Inbound `
    -Action Allow -Protocol UDP -LocalPort 22000
