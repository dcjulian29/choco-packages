# .NET 5 and above use the configured TLS version in the operating system
# On the Windows Insiders versions, they changed the default to 1.3
# TLS 1.3 seems to cause issues with NuGet, so disable until they fix it and I validate.
New-Item "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.3\Client" -Force | Out-Null

New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.3\Client" `
    -Name "Enabled" -Value "0" -PropertyType DWORD | Out-Null

$images = @(
    "alpine:latest"
    "mailhog/mailhog:latest"
    "mcr.microsoft.com/mssql/server:2019-latest"
    "mongo:latest"
    "redis:latest"
)

$images | ForEach-Object {
    Write-Output "-----$_"
    Pull-DockerImage -Name $_.Split(':')[0] -Tag $_.Split(':')[1]
}
