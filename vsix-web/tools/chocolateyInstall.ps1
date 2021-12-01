Write-Output "Installing VSIX Web Extensions..."

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
        "MadsKristensen.EditorEnhancements64"
        "MadsKristensen.HTMLSnippetPack"
        "MadsKristensen.JavaScriptSnippetPack"
        "MadsKristensen.WebAccessibilityChecker"
        "MadsKristensen.WebCompiler"
    )
}

if (Test-VisualStudioInstalledVersion 2019) {
    Write-Output "====== Visual Studio 2019 ====="
    installPackages @(
        "EricLebetsamer.BootstrapSnippetPack"
        "kspearrin.jQueryCodeSnippets"
        "MadsKristensen.BundlerMinifier"
        "MadsKristensen.CssTools2019"
        "MadsKristensen.EditorEnhancements"
        "MadsKristensen.HTMLSnippetPack"
        "MadsKristensen.JavaScriptSnippetPack"
        "MadsKristensen.VuejsPack2019"
        "MadsKristensen.WebAccessibilityChecker"
        "MadsKristensen.WebCompiler"
    )
}
