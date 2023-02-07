Download-File -Url "https://www.xmind.app/zen/download/win64" `
  -Destination $env:TEMP\xmind.exe

$hash = Get-Sha256 $env:TEMP\xmind.exe

if ($hash -ne '7CE976EF8EEDD2B3AC701521A0CEB6A89F5F3B88C5B67F12A0974B88B9B027D2') {
  throw "Checksum of downloaded installer does not verify!"
}

Start-Process -FilePath $env:TEMP\xmind.exe -NoNewWindow -Wait
