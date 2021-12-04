Import-Module PackageManagement -RequiredVersion 1.0.0.1
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted

Install-Module SqlServer -Force -AllowClobber
