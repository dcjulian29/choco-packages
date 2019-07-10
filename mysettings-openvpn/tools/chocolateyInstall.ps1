$packageName = "mysettings-openvpn"

if (Test-Path $env:SYSTEMDRIVE\etc\vpn) {
    Copy-Item -Path $env:SYSTEMDRIVE\etc\vpn\*.ovpn `
        -Destination $env:USERPROFILE\OpenVPN\config\ `
        -Verbose -Force
}
