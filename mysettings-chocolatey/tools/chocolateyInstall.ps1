icacls "${env:ALLUSERSPROFILE}\chocolatey" --% /grant Everyone:(OI)(CI)F /T

choco feature disable -n allowEmptyChecksums
choco feature disable -n exitOnRebootDetected
choco feature enable  -n logWithoutColor
choco feature disable -n powershellhost
choco feature enable  -n showNonElevatedWarnings
choco feature enable  -n showDownloadProgress
choco feature enable  -n stopOnFirstPackageFailure

choco config set --name 'cacheLocation' --value '%TEMP%'
choco config set --name 'commandExecutionTimeoutSeconds' --value '3600'
