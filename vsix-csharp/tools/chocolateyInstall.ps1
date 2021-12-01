Write-Output "Installing VSIX C# Extensions..."

Get-Module -Name VisualStudio -ListAvailable | Out-Null

$packages = @(
    "AndreasReischuck.SemanticColorizer"
    "DavidPerfors.RegionExpander"
    "DavidProthero.NgrokExtensions"
    "FinnGegenmantel.doxygenComments"
    "josefpihrt.Roslynator2022"
    "jsakamoto.CMethodsCodeSnippets"
    "LBHSR.ParallelChecker"
    "MadsKristensen.PackageSecurityAlerts"
    "MattLaceyLtd.WarnAboutTODOs"
    "mayerwin.DisableNoSourceAvailableTab"
    "PumaSecurity.PumaScan"
    "RandomEngy.UnitTestBoilerplateGenerator"
    "sergeb.GhostDoc"
    "SonarSource.SonarLintforVisualStudio2022"
    "SteveCadwallader.CodeMaidVS2022"
)

foreach ($package in $packages) {
    Install-VSIX $package
}
