Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted

Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force

Install-Module SqlServer -Force -AllowClobber
