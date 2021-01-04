# .NET 5 uses the configured TLS version in the operating system, and on Windows Insiders they changed the default to 1.3
# TLS 1.3 seems to cause issues with NuGet, so disable until they fix it.
New-Item "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.3\Client" -Force

New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.3\Client" `
    -Name "Enabled" -Value "0" –PropertyType DWORD

$images = @(
    "alpine"
    "docker.elastic.co/elasticsearch/elasticsearch:7.10.0"
    "docker.elastic.co/kibana/kibana:7.10.0"
    "graylog/graylog:4.0"
    "mailhog/mailhog:latest"
    "mcr.microsoft.com/dotnet/aspnet:5.0-buster-slim"
    "mcr.microsoft.com/dotnet/sdk:5.0-buster-slim"
    "mcr.microsoft.com/mssql/server:2019-latest"
    "mongo:latest"
    "mysql:latest"
    "postgres:latest"
    "redis:latest"
)

$images | ForEach-Object {
    Pull-DockerImage -Name $_.Split(':')[0] -Tag $_.Split(':')[1]
}

## DotNet Tool installs:
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

# Newer installs of the Google Chrome is putting the files in Program Files instead of PF32...
# Until, I get all of my existing systems converted to "Program Files", I'll create a link in PF32
if (-not (Test-Path "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe")) {
    New-Item -ItemType Directory `
        -Path "C:\Program Files (x86)\Google\Chrome\Application" | Out-Null

    New-Item -ItemType SymbolicLink -Name "chrome.exe" `
        -Path "C:\Program Files (x86)\Google\Chrome\Application" `
        -Target "C:\Program Files\Google\Chrome\Application\chrome.exe" | Out-Null
}
