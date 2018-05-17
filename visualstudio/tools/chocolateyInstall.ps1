$packageName = "visualstudio"
$downloadPath = "$env:TEMP\$packageName"

$url = "https://download.visualstudio.microsoft.com/download/pr/10753574/52257ee3e96d6e07313e41ad155b155a/vs_Enterprise.exe"

if (Test-Path $downloadPath) {
    Remove-Item -Path $downloadPath -Recurse -Force
}

New-Item -Type Directory -Path $downloadPath | Out-Null

Download-File $url "$downloadPath\vs_enterprise.exe"

$installerArgs = "--norestart --passive"

$Workloads = @(
    "Microsoft.VisualStudio.Workload.Data"
    "Microsoft.VisualStudio.Workload.ManagedDesktop"
    "Microsoft.VisualStudio.Workload.NetCoreTools"
    "Microsoft.VisualStudio.Workload.NetWeb"
    "Microsoft.VisualStudio.Workload.Azure"
    "Microsoft.Net.Component.4.7.1.TargetingPack"
    "Microsoft.Net.ComponentGroup.4.7.1.DeveloperTools"
    "Microsoft.VisualStudio.Component.IntelliTrace.FrontEnd"
    "Microsoft.VisualStudio.Component.DockerTools"
)

$Workloads | foreach { $installerArgs += " --add $_" }

$installerArgs += " --wait"

Invoke-ElevatedCommand "$downloadPath\vs_enterprise.exe" -ArgumentList $installerArgs -Wait

Write-Output "Installing IIS Server..."

$features = @(
    "IIS-WebServerRole",
    "IIS-NetFxExtensibility45",
    "IIS-LoggingLibraries",
    "IIS-RequestMonitor",
    "IIS-HttpTracing",
    "IIS-ISAPIExtensions",
    "IIS-ISAPIFilter",
    "IIS-CustomLogging",
    "IIS-ASPNET45",
    "IIS-ManagementScriptingTools"
)

foreach ($feature in $features) {
    $enabled = (Get-WindowsOptionalFeature -Online `
        | where { $_.FeatureName -eq $feature -and $_.State -eq "Disabled" }).State
    if ($enabled -eq "Disabled") {
        Write-Output "Enabling $feature..."
        Enable-WindowsOptionalFeature -Online -FeatureName $feature | Out-Null
    }
}

& $env:WINDIR\system32\iisreset.exe
