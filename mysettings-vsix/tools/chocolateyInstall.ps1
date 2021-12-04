Write-Output "Installing VSIX Extensions..."

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
        "EWoodruff.VisualStudioSpellCheckerVS2022andLater"
        "HaloSugar.MonokaiPro"
        "LaurentKempe.GitDiffMargin"
        "MadsKristensen.FileIcons"
        "NikolayBalakin.Outputenhancer"
    )
}

if (Test-VisualStudioInstalledVersion 2019) {
    Write-Output "====== Visual Studio 2019 ====="
    installPackages @(
        "pid011.MonokaiVS"
        "ErlandR.ReAttach"
        "EWoodruff.VisualStudioSpellCheckerVS2017andLater"
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
}

$file = "${env:TEMP}\$([Guid]::NewGuid()).vsix"

Invoke-WebRequest 'https://julianscorner.com/dl/JulianSnippets.vsix' -OutFile $file

Write-Output "  "
Write-Output "---------- JulianSnippets"
Install-VsixPackage -Path $file -Package "JulianSnippets"
