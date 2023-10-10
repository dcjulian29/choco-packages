Write-Output "Installing Julian's Root CA Certificates..."
Invoke-WebRequest "https://julianscorner.com/dl/c/julianca.crt" -OutFile "${env:TEMP}\julianca.crt"
Import-Certificate -FilePath "${env:TEMP}\julianca.crt" -CertStoreLocation Cert:\LocalMachine\Root

Write-Output "Installing Julian's Intermediate CA certificates..."
Invoke-WebRequest "https://julianscorner.com/dl/c/intermediate.crt" -OutFile "${env:TEMP}\intermediate.crt"
Import-Certificate -FilePath "${env:TEMP}\intermediate.crt" -CertStoreLocation Cert:\LocalMachine\CA

Invoke-WebRequest "https://julianscorner.com/dl/c/jnet_ca.crt" -OutFile "${env:TEMP}\jnet_ca.crt"
Import-Certificate -FilePath "${env:TEMP}\jnet_ca.crt" -CertStoreLocation Cert:\LocalMachine\CA

Invoke-WebRequest "https://julianscorner.com/dl/c/acme_ca.crt" -OutFile "${env:TEMP}\acme_ca.crt"
Import-Certificate -FilePath "${env:TEMP}\acme_ca.crt" -CertStoreLocation Cert:\LocalMachine\CA
