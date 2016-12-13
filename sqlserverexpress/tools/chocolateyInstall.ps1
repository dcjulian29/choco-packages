$packageName = "sqlserverexpress"
$url = "https://julianscorner.com/downloads/sql2016.1.zip"
$downloadPath = "$($env:TEMP)\$packageName"
$dataDir = "$($env:SYSTEMDRIVE)\data"

$sid = New-Object Security.Principal.SecurityIdentifier 'S-1-5-32-544'
$administrators = $sid.Translate([Security.Principal.NTAccount]).Value

$arg1 = "/QS /ACTION=Install /FEATURES=SQL /TCPENABLED=1 /SKIPRULES=""RebootRequiredCheck"""
$arg2 = "/INSTANCENAME=MSSQLSERVER /SQLSVCACCOUNT=""NT AUTHORITY\Network Service"""
$arg3 = "/SQLSYSADMINACCOUNTS=""$($administrators)"" /INSTALLSQLDATADIR=""$($dataDir)"""
$arg4 = "/AGTSVCACCOUNT=""NT AUTHORITY\Network Service"" /IACCEPTSQLSERVERLICENSETERMS"

$installerArgs = "$arg1 $arg2 $arg3 $arg4"

if (-not (Test-Path $dataDir)) {
    New-Item -Type Directory -Path $dataDir | Out-Null
}

if (Test-Path $downloadPath) {
    Remove-Item -Path $downloadPath -Recurse -Force
}

New-Item -Type Directory -Path $downloadPath | Out-Null

Download-File $url "$downloadPath\$packageName.zip"
Unzip-File "$downloadPath\$packageName.zip" "$downloadPath\"

Invoke-Expression "$downloadPath\setup.exe $installerArgs"

Wait-Process -Name "SETUP" -ErrorAction Silent
