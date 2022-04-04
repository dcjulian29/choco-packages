$teamCityURL  = "https://teamcity.julianscorner.com"

$rootCertificate = "https://julianscorner.com/dl/c/julianca.crt"
$certificateURLs = @(
  "https://julianscorner.com/dl/c/acme_ca.crt"
  "https://julianscorner.com/dl/c/intermediate.crt"
  "https://julianscorner.com/dl/c/jnet_ca.crt"
)

$rootFile = Split-Path -Leaf -Path $rootCertificate

Invoke-WebRequest -Uri $rootCertificate -OutFile "${env:TEMP}\$rootFile" -UseBasicParsing
Import-Certificate -FilePath "${env:TEMP}\$rootFile" -CertStoreLocation Cert:\LocalMachine\Root

foreach ($url in $certificateURLs) {
  $filename = Split-Path -Leaf -Path $url

  Invoke-WebRequest -Uri $url -OutFile "${env:TEMP}\$filename" -UseBasicParsing
  Import-Certificate -FilePath "${env:TEMP}\$filename" -CertStoreLocation Cert:\LocalMachine\Ca
}

Invoke-WebRequest -Uri $teamCityURL -OutFile "${env:TEMP}\buildagent.zip" -UseBasicParsing

Expand-Archive -Path "${env:TEMP}\buildagent.zip" -DestinationPath "E:\buildAgent"

if (-not (Test-Path "E:\buildAgent\system\serverTrustedCertificates")) {
  New-Item -Path "E:\buildAgent\system\serverTrustedCertificates" -ItemType Directory | Out-Null
}

Copy-Item "${env:TEMP}\$rootFile" -Destination "E:\buildAgent\system\serverTrustedCertificates\"

& "E:\buildAgent\bin\service.install.bat"
