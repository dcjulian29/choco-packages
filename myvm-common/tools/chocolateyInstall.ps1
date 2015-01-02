$packageName = "myvm-common"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try {

    if (-not (Test-Path $env:SYSTEMDRIVE\etc))
    {
        New-Item -Type Directory -Path $env:SYSTEMDRIVE\etc | Out-Null
    }
    
    Write-ChocolateySuccess $packageName
} catch {
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
