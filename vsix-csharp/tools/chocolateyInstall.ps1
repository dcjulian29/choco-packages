Write-Output "Installing VSIX C# Extensions..."

Get-Module -Name VisualStudio -ListAvailable | Out-Null

function installPackages($packages) {
    foreach ($package in $packages) {
        Write-Output "  "
        Write-Output "---------- $package"
        Install-VsixByName -PackageName $package
    }
}

installPackages @(
    "FinnGegenmantel.doxygenComments"
    "josefpihrt.Roslynator2022"
    "jsakamoto.CMethodsCodeSnippets"
    "LBHSR.ParallelChecker"
    "MattLaceyLtd.WarnAboutTODOs"
    "PumaSecurity.PumaScan2022"
    "RandomEngy.UnitTestBoilerplateGenerator"
    "sergeb.GhostDoc"
    "SonarSource.SonarLintforVisualStudio2022"
    "SteveCadwallader.CodeMaidVS2022"
    "TechTalkSpecFlowTeam.SpecFlowForVisualStudio2022"
    "TomEnglert.Wax"
    "WixToolset.WixToolsetVisualStudio2022Extension"
    "vscps.SlowCheetah-XMLTransforms-VS2022"
)
