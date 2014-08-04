$packageName = "mycomputers-family"

Start-Transcript -Path "$($env:TEMP)\mycomputers-family.transcript.log" -Append

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try {    
    cinst mysettings-homeserverclient
    cinst flux
    cinst java
    cinst notepadplusplus
    cinst sumatrapdf
    cinst tightvnc

    Write-ChocolateySuccess $packageName        
} catch {
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}

Stop-Transcript

