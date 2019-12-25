icacls "${env:ALLUSERSPROFILE}\chocolatey" --% /grant Everyone:(OI)(CI)F /T

choco feature enable -n allowEmptyChecksums
choco feature enable -n logWithoutColor

choco feature disable -n exitOnRebootDetected
choco feature disable -n showNonElevatedWarnings
choco feature disable -n showDownloadProgress

choco config set --name 'commandExecutionTimeoutSeconds' --value '3600'
