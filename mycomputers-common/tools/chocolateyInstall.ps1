$packageName = "mycomputers-common"

Start-Transcript -Path "$($env:TEMP)\mycomputers-common.transcript.log" -Append

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try {    
    cinst mysettings-ntfs
    cinst mysettings-ipv6
    cinst dotnet
    cinst powershell
    cinst pdfcreator

    Write-ChocolateySuccess $packageName
        
} catch {
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}

Stop-Transcript

