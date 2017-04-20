$packageName = "visualstudio"
$downloadPath = "$env:TEMP\$packageName"

$url = "https://download.microsoft.com/download/A/A/3/AA372A6A-C137-474D-95B6-865AF23DF0E1/vs_enterprise.exe"

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
    "Component.Redgate.ReadyRoll"
    "Component.Redgate.SQLPrompt.VsPackage"
    "Microsoft.Net.Component.4.6.2.TargetingPack"
    "Microsoft.Net.ComponentGroup.4.6.2.DeveloperTools"
    "Microsoft.VisualStudio.Component.IntelliTrace.FrontEnd"
    "Microsoft.VisualStudio.Component.DockerTools"
)

$Workloads | foreach { $installerArgs += " --add $_" }

$installerArgs += " --wait"

Invoke-ElevatedCommand "$downloadPath\vs_enterprise.exe" -ArgumentList $installerArgs -Wait
