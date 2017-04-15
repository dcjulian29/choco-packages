$packageName = "mysettings-syncthing"

$location = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"

$key = Get-Item $location
if ($key.GetValue("syncthing", $null) -ne $null) {
    Remove-ItemProperty -Path $location -Name "syncthing"
}
