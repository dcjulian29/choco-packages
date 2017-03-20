$packageName = "sqlserverexpress"
$url = "https://download.microsoft.com/download/9/0/7/907AD35F-9F9C-43A5-9789-52470555DB90/ENU/SQLEXPR_x64_ENU.exe"
$downloadPath = "$env:LOCALAPPDATA\Temp\$packageName"

$sid = New-Object Security.Principal.SecurityIdentifier 'S-1-5-32-544'
$administrators = $sid.Translate([Security.Principal.NTAccount]).Value

$arg1 = "/QS /ACTION=Install /FEATURES=SQL /TCPENABLED=1 /SKIPRULES=""RebootRequiredCheck"""
$arg2 = "/INSTANCENAME=MSSQLSERVER /SQLSVCACCOUNT=""NT AUTHORITY\Network Service"""
$arg3 = "/SQLSYSADMINACCOUNTS=""$($administrators)"""
$arg4 = "/AGTSVCACCOUNT=""NT AUTHORITY\Network Service"" /IACCEPTSQLSERVERLICENSETERMS"

$installerArgs = "$arg1 $arg2 $arg3 $arg4"

if (Test-Path $downloadPath) {
    Remove-Item -Path $downloadPath -Recurse -Force
}

New-Item -Type Directory -Path $downloadPath | Out-Null

Download-File $url "$downloadPath\$packageName.exe"

Start-Process "$downloadPath\$packageName.exe" "/Q /x:`"$downloadPath\sql`"" -Wait

Start-Process "$downloadPath\sql\setup.exe" "$installerArgs" -Wait
