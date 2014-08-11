$packageName = "mycomputers-family"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try {    

    Start-ChocolateyProcessAsAdmin "Enable-PSRemoting -Force"
    
    Write-ChocolateySuccess $packageName        

} catch {
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
