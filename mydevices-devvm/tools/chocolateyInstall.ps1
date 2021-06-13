# .NET 5 uses the configured TLS version in the operating system, and on Windows Insiders they changed the default to 1.3
# TLS 1.3 seems to cause issues with NuGet, so disable until they fix it.
New-Item "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.3\Client" -Force

New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.3\Client" `
    -Name "Enabled" -Value "0" -PropertyType DWORD

$images = @(
    "alpine:latest"
    "mailhog/mailhog:latest"
    "mcr.microsoft.com/dotnet/aspnet:5.0-buster-slim"
    "mcr.microsoft.com/dotnet/sdk:5.0-buster-slim"
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

# Newer installs of the Google Chrome are putting the files in Program Files instead of PF32...
# Until, I get all of my existing systems converted to "Program Files", I'll create a link in PF32
if (Test-Path 'C:\Program Files\Google\Chrome\Application\chrome.exe') {
    if (-not (Test-Path 'C:\Program Files (x86)\Google\Chrome\Application\chrome.exe')) {
        New-Item -ItemType Directory `
            -Path 'C:\Program Files (x86)\Google\Chrome\Application' | Out-Null

        New-Item -ItemType SymbolicLink -Name 'chrome.exe' `
            -Path 'C:\Program Files (x86)\Google\Chrome\Application' `
            -Target 'C:\Program Files\Google\Chrome\Application\chrome.exe' | Out-Null
    }
} else {
    Write-Warning "Google Chrome is not installed... Check to see why!"
}
