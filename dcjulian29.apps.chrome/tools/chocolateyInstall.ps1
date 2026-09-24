$ErrorActionPreference = 'Stop'

$is64 = [Environment]::Is64BitOperatingSystem -and ($env:ChocolateyForceX86 -ne 'true')
$url = if ($is64) {
  'https://dl.google.com/dl/chrome/install/googlechromestandaloneenterprise64.msi'
} else {
  'https://dl.google.com/dl/chrome/install/googlechromestandaloneenterprise.msi'
}

$msi = Join-Path $env:TEMP (Split-Path $url -Leaf)

Remove-Item $msi -Force -ErrorAction SilentlyContinue

$ProgressPreference = 'SilentlyContinue'   # PS 5.1 IWR is painfully slow with progress on

Write-Host "Downloading $url"
Invoke-WebRequest -Uri $url -OutFile $msi -UseBasicParsing

$sig = Get-AuthenticodeSignature -FilePath $msi

if ($sig.Status -ne 'Valid' -or $sig.SignerCertificate.Subject -notmatch 'O=Google LLC') {
  throw "Signature check failed on $msi (Status: $($sig.Status); Signer: $($sig.SignerCertificate.Subject))"
}

Write-Host "$($sig.StatusMessage) $($sig.SignerCertificate.Subject)"

$installArgs = @{
  PackageName    = 'googlechrome'
  FileType       = 'MSI'
  SilentArgs     = '/quiet /norestart'
  File           = $msi
  ValidExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyInstallPackage @installArgs

Remove-Item $msi -Force -ErrorAction SilentlyContinue
