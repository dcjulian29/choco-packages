$installArgs = @{
  PackageName    = "googlechrome"
  FileType       = "MSI"
  SilentArgs     = "/quiet /norestart"
  url            = 'https://dl.google.com/dl/chrome/install/googlechromestandaloneenterprise.msi'
  url64bit       = 'https://dl.google.com/dl/chrome/install/googlechromestandaloneenterprise64.msi'
  ValidExitCodes = @(0)
}

Install-ChocolateyPackage @installArgs
