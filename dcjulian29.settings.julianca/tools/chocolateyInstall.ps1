Write-Host "Scanning for Certificate Authority files in: $PSScriptRoot" -ForegroundColor Cyan

$files = Get-ChildItem -Path $PSScriptRoot -Filter "*.crt" -File

if ($files.Count -eq 0) {
  Write-Warning "No Certificate Authorities found."
  exit 0
}

Write-Host "Found $($files.Count) certificate(s) to import.`n" -ForegroundColor Cyan

foreach ($file in $files) {
  try {
    Write-Host "Importing: $($file.Name)" -ForegroundColor Yellow

    $cert = New-Object `
      System.Security.Cryptography.X509Certificates.X509Certificate2 `
      $file.FullName

    $store = New-Object System.Security.Cryptography.X509Certificates.X509Store(
      [System.Security.Cryptography.X509Certificates.StoreName]::Root,
      [System.Security.Cryptography.X509Certificates.StoreLocation]::LocalMachine
    )

    $store.Open([System.Security.Cryptography.X509Certificates.OpenFlags]::ReadWrite)
    $store.Add($cert)
    $store.Close()

    Write-Host "  [OK]      Successfully imported '$($file.Name)'" -ForegroundColor Green
    Write-Host "            Subject : $($cert.Subject)"
    Write-Host "            Thumbprint: $($cert.Thumbprint)"
    Write-Host "            Expires  : $($cert.NotAfter)`n"
  }
  catch {
    Write-Host "  [FAILED]  Could not import '$($file.Name)': $_" -ForegroundColor Red
  }
}
