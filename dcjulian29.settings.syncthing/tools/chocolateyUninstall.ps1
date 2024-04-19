$location = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
$key = Get-Item $location

if ($null -ne $key.GetValue("syncthing", $null)) {
  Remove-ItemProperty -Path $location -Name "syncthing" -Force
}

Remove-NetFirewallRule -DisplayName 'Syncthing-Inbound-TCP'
Remove-NetFirewallRule -DisplayName 'Syncthing-Inbound-UDP'
