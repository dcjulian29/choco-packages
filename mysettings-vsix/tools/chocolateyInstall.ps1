Write-Output "Installing VSIX Extensions..."

Get-Module -Name VisualStudio -ListAvailable | Out-Null

$packages = @(
    "ErlandR.ReAttach"
    "EWoodruff.VisualStudioSpellCheckerVS2022andLater"
    "GitHub.GitHubExtensionforVisualStudio"
    "HaloSugar.MonokaiPro"
    "LaurentKempe.GitDiffMargin"
    "MadsKristensen.EditorConfig"
    "MadsKristensen.FileIcons"
    "MadsKristensen.ignore"
    "MadsKristensen.SyntaxHighlightingPack"
    "MadsKristensen.TrailingWhitespaceVisualizer"
    "NikolayBalakin.Outputenhancer"
    "PaulHarrington.PerfWatsonMonitor-9621"
    "SergeyVlasov.FixFileEncoding"
    "VisualStudioPlatformTeam.FixMixedTabs"
    "VisualStudioPlatformTeam.SolutionErrorVisualizer"
    "VisualStudioPlatformTeam.SyntacticLineCompression"
)

foreach ($package in $packages) {
    Install-VSIX $package
}

$file = "${env:TEMP}\$([Guid]::NewGuid()).vsix"

Invoke-WebRequest 'https://julianscorner.com/dl/JulianSnippets.vsix' -OutFile $file

Install-VsixPackage -Path $file -Package "JulianSnippets"
