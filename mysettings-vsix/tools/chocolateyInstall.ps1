Write-Output "Installing VSIX Extensions..."

Get-Module -Name VisualStudio -ListAvailable | Out-Null

function installPackages($packages) {
    foreach ($package in $packages) {
        Write-Output "  "
        Write-Output "---------- $package"
        Install-VsixByName -PackageName $package
    }
}

installPackages @(
    "AndreasReischuck.SemanticColorizer"
    "EWoodruff.VisualStudioSpellCheckerVS2022andLater"
    "idex.vsthemepack"
    "ErlandR.ReAttach"
    "LaurentKempe.GitDiffMargin"
    "MadsKristensen.FileIcons"
    "MadsKristensen.MarkdownEditor2"
    "MadsKristensen.Terraform"
    "MadsKristensen.TrailingWhitespace64"
    "MadsKristensen.Tweaks2022"
    "MikeWard-AnnArbor.VSColorOutput64"
    "PaulHarrington.EditorGuidelinesPreview"
    "SergeyVlasov.FixFileEncoding"
    "VisualStudioPlatformTeam.FixMixedTabs2022"
    "VisualStudioPlatformTeam.SyntacticLineCompression2022"
    "vs-publisher-57624.GitFlowforVisualStudio2022"
)

$file = "${env:TEMP}\$([Guid]::NewGuid()).vsix"

Invoke-WebRequest 'https://julianscorner.com/dl/JulianSnippets.vsix' -OutFile $file

Write-Output "  "
Write-Output "---------- JulianSnippets"
Install-VsixPackage -Path $file -Package "JulianSnippets"
