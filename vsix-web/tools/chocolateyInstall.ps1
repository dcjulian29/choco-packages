Write-Output "Installing VSIX Web Extensions..."

Get-Module -Name VisualStudio -ListAvailable | Out-Null

$packages = @(
    "EricLebetsamer.BootstrapSnippetPack"
    "kspearrin.jQueryCodeSnippets"
    "MadsKristensen.BundlerMinifier"
    "MadsKristensen.CssTools2019"
    "MadsKristensen.EditorEnhancements64"
    "MadsKristensen.HTMLSnippetPack"
    "MadsKristensen.JavaScriptSnippetPack"
    "MadsKristensen.VuejsPack2019"
    "MadsKristensen.WebAccessibilityChecker"
    "MadsKristensen.WebCompiler"
}

foreach ($package in $packages) {
    Install-VSIX $package
}
