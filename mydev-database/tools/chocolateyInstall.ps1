$packageName = "mydev-database"

Invoke-ElevatedCommand "sc.exe" -ArgumentList "config MSSQLSERVER start= demand" -Wait

Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted

Install-Module SqlServer -Force -AllowClobber
