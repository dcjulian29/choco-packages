$packageName = "sql-server-express"
$url = "https://download.microsoft.com/download/7/f/8/7f8a9c43-8c8a-4f7c-9f92-83c18d96b681/SQL2019-SSEI-Expr.exe"
$downloadPath = "$env:TEMP\$packageName"

if (Test-Path $downloadPath) {
    Remove-Item -Path $downloadPath -Recurse -Force
}

New-Item -Type Directory -Path $downloadPath | Out-Null

Download-File $url "$downloadPath\$packageName.exe"

Start-Process "$downloadPath\$packageName.exe" "/ConfigurationFile=""$env:SystemDrive\etc\sql\setupconfig.ini"" /IACCEPTSQLSERVERLICENSETERMS /MEDIAPATH=""$env:TEMP\SQL2019"" /Q" -Wait

Install-Module -Name SqlServer -AllowClobber
