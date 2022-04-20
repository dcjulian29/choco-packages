#icacls "${env:ALLUSERSPROFILE}\chocolatey" --% /grant Everyone:(OI)(CI)F /T

choco feature disable -n logWithoutColor
choco feature disable -n logEnvironmentValues
choco feature enable  -n showNonElevatedWarnings
choco feature disable -n showDownloadProgress
choco feature enable  -n useRememberedArgumentsForUpgrades 
choco feature enable  -n logValidationResultsOnWarnings 

choco feature enable  -n autoUninstaller 
choco feature disable -n failOnAutoUninstaller

choco feature disable -n usePackageExitCodes
choco feature disable -n useEnhancedExitCodes
choco feature disable -n exitOnRebootDetected

choco feature enable  -n ignoreInvalidOptionsSwitches
choco feature enable  -n failOnStandardError
choco feature enable  -n stopOnFirstPackageFailure
choco feature disable -n skipPackageUpgradesWhenNotInstalled
choco feature disable -n ignoreUnfoundPackagesOnUpgradeOutdated
choco feature enable  -n usePackageRepositoryOptimizations

choco feature disable -n useFipsCompliantChecksums
choco feature enable  -n checksumFiles
choco feature disable -n allowEmptyChecksums
choco feature disable -n allowEmptyChecksumsSecure
choco feature disable -n allowGlobalConfirmation

choco feature disable -n powershellHost
choco feature enable  -n scriptsCheckLastExitCode
choco feature enable  -n removePackageInformationOnUninstall

##############################################################################

choco config set --name 'cacheLocation' --value '%TEMP%'
choco config set --name 'upgradeAllExceptions' --value ''
choco config set --name 'defaultTemplateName' --value ''

choco config set --name 'proxy' --value ''
choco config set --name 'proxyUser' --value ''
choco config set --name 'proxyPassword' --value ''
choco config set --name 'proxyBypassList' --value ''
choco config set --name 'proxyBypassOnLocal' --value 'true'

choco config set --name 'commandExecutionTimeoutSeconds' --value '3600'
choco config set --name 'webRequestTimeoutSeconds ' --value '60'

choco config set --name 'containsLegacyPackageInstalls' --value 'false'
