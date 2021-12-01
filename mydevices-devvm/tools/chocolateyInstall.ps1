# .NET 5 uses the configured TLS version in the operating system, and on Windows Insiders they changed the default to 1.3
# TLS 1.3 seems to cause issues with NuGet, so disable until they fix it.
New-Item "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.3\Client" -Force

New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.3\Client" `
    -Name "Enabled" -Value "0" -PropertyType DWORD

$images = @(
    "alpine:latest"
    "mailhog/mailhog:latest"
    "mcr.microsoft.com/dotnet/aspnet:6.0-bullseye-slim"
    "mcr.microsoft.com/dotnet/sdk:6.0-bullseye-slim"
    "mcr.microsoft.com/mssql/server:2019-latest"
    "mongo:latest"
    "redis:latest"
)

$images | ForEach-Object {
    Pull-DockerImage -Name $_.Split(':')[0] -Tag $_.Split(':')[1]
}

#Disable Telemetry
Set-EnvironmentVariable -Name "DOTNET_CLI_TELEMETRY_OPTOUT" -Value 1 -Scope "Machine"

# Ensure that the v3 NuGet feed is enabled
nuget sources add -Name "NuGet Official Package Source" -Source "https://api.nuget.org/v3/index.json"

# DotNet Tool installs:
dotnet tool install --global Cake.Tool
dotnet tool install --global dotnet-format
dotnet tool install --global dotnet-xdt
dotnet tool install --global dotnet-ildasm
dotnet tool install --global dotnet-deb
dotnet tool install --global dotnet-rpm
dotnet tool install --global dotnet-zip
dotnet tool install --global dotnet-tarball
dotnet tool install --global dotnet-outdated-tool
dotnet tool install --global dotnet-delice
dotnet tool install --global BenchmarkDotNet.Tool

Write-Output "Checking to see if code folder needs to be restored..."
if (-not (Test-Path $(Get-DefaultCodeFolder)\BACKUP-CodeDirectory.bat)) {
    if (Test-Path $env:SYSTEMDRIVE\etc\Restore-CodeDirectory.cmd) {
        Write-Output "  - Restoring code folder..."
        & $env:SYSTEMDRIVE\etc\Restore-CodeDirectory.cmd
    }
}
