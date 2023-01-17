$version = "4.0.2"
$url = "https://2.na.dl.wireshark.org/win64/Wireshark-win64-$version.exe"
$prop = @(
    "/S"
    "/EXTRACOMPONENTS=sshdump,udpdump,etwdump,wifidump"
    "/DESKTOPICON=no"
    "/QUICKLAUNCHICON=no"
)

Push-Location $env:TEMP

Download-File -Url $url -Destination "wireshark.exe"

if (-not (Test-Path -Path "./wireshark.exe")) {
  throw "Error downloading wireshark!"
}

Invoke-Expression "./wireshark.exe $($prop -join ' ')"

Pop-Location
