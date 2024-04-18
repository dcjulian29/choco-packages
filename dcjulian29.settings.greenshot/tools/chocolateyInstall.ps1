if (Get-Process -Name Greenshot -ErrorAction SilentlyContinue) {
  Stop-Process -Name Greenshot -Force
}

$ini = Get-Content -Path "${env:APPDATA}\Greenshot\Greenshot.ini"

$ini = $ini.Replace("OutputFileFilenamePattern=`${capturetime:d""yyyy-MM-dd HH_mm_ss""}-`${title}", `
  "OutputFileFilenamePattern=`${capturetime:d""yyyy-MM-dd HH_mm_ss""}")

$ini = $ini.Replace("OutputFilePath=${env:USERPROFILE}\Desktop", "OutputFilePath=${env:USERPROFILE}\Pictures")

Set-Content -Path "${env:APPDATA}\Greenshot\Greenshot.ini" -Value $ini

$key = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
$exists = $null -ne (Get-ItemProperty $key "Greenshot")

if ($exists) {
  Remove-ItemProperty -Path $key -Name Greenshot
}
