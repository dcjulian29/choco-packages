Write-Output "Installing VSIX C# Extensions..."

Get-Module -Name VisualStudio -ListAvailable | Out-Null

function installPackages($packages) {
    foreach ($package in $packages) {
        Write-Output "  "
        Write-Output "---------- $package"
        Install-VsixByName -PackageName $package
    }
}

if (Test-VisualStudioInstalledVersion 2022) {
    Write-Output "====== Visual Studio 2022 ====="
    installPackages @(
        "FinnGegenmantel.doxygenComments"
        "josefpihrt.Roslynator2022"
        "jsakamoto.CMethodsCodeSnippets"
        "LBHSR.ParallelChecker"
        "MattLaceyLtd.WarnAboutTODOs"
        "RandomEngy.UnitTestBoilerplateGenerator"
        "SonarSource.SonarLintforVisualStudio2022"
        "SteveCadwallader.CodeMaidVS2022"
    )
}

if (Test-VisualStudioInstalledVersion 2019) {
    Write-Output "====== Visual Studio 2019 ====="
    installPackages @(
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
        "SonarSource.SonarLintforVisualStudio2019"
        "SteveCadwallader.CodeMaid"
    )
}
