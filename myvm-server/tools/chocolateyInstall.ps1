$packageName = "myvm-server"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try {

    Get-AppxProvisionedPackage -Online | Remove-AppxProvisionedPackage -Online | Out-Null
    Get-AppxPackage | Remove-AppxPackage -ea Silent

    Write-Output "Enabling Remote Desktop ..."
    $settings = Get-WmiObject -Class "Win32_TerminalServiceSetting" `
        -Namespace root\cimv2\terminalservices
    $settings.SetAllowTsConnections(1)

    netsh advfirewall firewall set rule group="Remote Desktop" new enable=yes

    cinst mysettings-notepadedit
    
    Write-ChocolateySuccess $packageName
} catch {
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
