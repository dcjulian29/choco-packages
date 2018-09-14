$packageName = "mydev-database"

Invoke-ElevatedCommand "sc.exe" -ArgumentList "config MongoDb start= demand" -Wait
Invoke-ElevatedCommand "sc.exe" -ArgumentList "config MSSQLSERVER start= demand" -Wait

$service = Get-Service | Where-Object { $_.Name -like "postgresql*" }
Invoke-ElevatedCommand "sc.exe" -ArgumentList "config $($service.Name) start= demand" -Wait

Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted

Install-Module SqlServer -Force -AllowClobber
