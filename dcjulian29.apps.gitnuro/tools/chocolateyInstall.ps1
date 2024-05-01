$installArgs = @{
  PackageName    = "Gitnuro"
  FileType       = "EXE"
  SilentArgs     = "/S"
  url            = "https://github.com/JetpackDuba/Gitnuro/releases/download/v1.3.1/Gitnuro_Windows_Installer_1.3.1.exe"
  checksum       = "fef126513c3b1a1f1ce29673f596547b16e31103cbc31007297f77b92e91b0eb"
  checksumType   = "sha256"
}

Install-ChocolateyPackage @installArgs
