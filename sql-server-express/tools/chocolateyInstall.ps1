$packageName = "sql-server-express"
$url = "https://download.microsoft.com/download/2/1/6/216eb471-e637-4517-97a6-b247d8051759/SQL2019-SSEI-Expr.exe"
$downloadPath = "$env:TEMP\$packageName"

if (Test-Path $downloadPath) {
    Remove-Item -Path $downloadPath -Recurse -Force
}

New-Item -Type Directory -Path $downloadPath | Out-Null

Download-File $url "$downloadPath\$packageName.exe"

Start-Process "$downloadPath\$packageName.exe" "/ConfigurationFile=""$env:SystemDrive\etc\sql\setupconfig.ini"" /IACCEPTSQLSERVERLICENSETERMS /MEDIAPATH=""$env:TEMP\SQL2019"" /Q" -Wait

Install-Module -Name SqlServer -AllowClobber
