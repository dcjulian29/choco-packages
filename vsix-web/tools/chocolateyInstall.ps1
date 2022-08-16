Write-Output "Installing VSIX Web Extensions..."

Get-Module -Name VisualStudio -ListAvailable | Out-Null

function installPackages($packages) {
    foreach ($package in $packages) {
        Write-Output "  "
        Write-Output "---------- $package"
        Install-VsixByName -PackageName $package
    }
}

installPackages @(
    "MadsKristensen.EditorEnhancements64"
    "MadsKristensen.HTMLSnippetPack"
    "MadsKristensen.JavaScriptSnippetPack"
    "MadsKristensen.WebAccessibilityChecker"
    "MadsKristensen.WebCompiler"
)
