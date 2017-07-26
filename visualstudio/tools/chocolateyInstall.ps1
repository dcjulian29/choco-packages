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
    "Microsoft.Net.Component.4.6.2.TargetingPack"
    "Microsoft.Net.ComponentGroup.4.6.2.DeveloperTools"
    "Microsoft.VisualStudio.Component.IntelliTrace.FrontEnd"
    "Microsoft.VisualStudio.Component.DockerTools"
)

$Workloads | foreach { $installerArgs += " --add $_" }

$installerArgs += " --wait"

Invoke-ElevatedCommand "$downloadPath\vs_enterprise.exe" -ArgumentList $installerArgs -Wait
