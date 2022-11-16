#Disable Telemetry
Set-EnvironmentVariable -Name "DOTNET_CLI_TELEMETRY_OPTOUT" -Value 1 -Scope "Machine"

# Ensure that the v3 NuGet feed is enabled
nuget sources add -Name "NuGet Official Package Source" -Source "https://api.nuget.org/v3/index.json"

Write-Output "-n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
dotnet sdk check
Write-Output "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`n"

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
