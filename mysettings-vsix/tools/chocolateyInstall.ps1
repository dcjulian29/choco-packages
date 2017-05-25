$packageName = "mysettings-vsix"
$vsgallery = "https://visualstudiogallery.msdn.microsoft.com"

$downloadPath = "$env:TEMP\$packageName"

if (Test-Path $downloadPath) {
    Remove-Item -Path $downloadPath -Recurse -Force
}

New-Item -Type Directory -Path $downloadPath | Out-Null

$vsix = "C:\Program Files"

if (Test-Path "C:\Program Files (x86)") {
    $vsix = "C:\Program Files (x86)"
}

$vsix = "$vsix\Microsoft Visual Studio\2017\Enterprise\Common7\IDE\VSIXInstaller.exe"

Function Install-VSIX {
    param (
        [string]$Name,
        [string]$Url
    )

    ""
    "Installing $Name Extension..."

    $invalidChars = [IO.Path]::GetInvalidFileNameChars() -join ''
    $re = "[{0}]" -f [RegEx]::Escape($invalidChars)
    $Name = ($Name -replace $re)

    if (Test-Path "$downloadPath\$Name.vsix") {
        Remove-Item "$downloadPath\$Name.vsix" -Force
    }

    Download-File "$vsgallery/$Url" "$downloadPath\$Name.vsix"

    Start-Process -FilePath $vsix -NoNewWindow -Wait `
        -ArgumentList "/quiet /logFile:""$downloadPath\$Name.log"" ""$downloadPath\$Name.vsix"""

    if (Get-Content "$downloadPath\$Name.log" | Select-String -Pattern "Install Error") {
        Write-Warning "An error occurred Installing $Name Extension..."
        Write-Warning "Review the log file: $logFile"
        throw
    }

}

#### Web Essentials 2017
Install-VSIX "Bundler & Minifier" "9ec27da7-e24b-4d56-8064-fd7e88ac1c40/file/164487/42/Bundler%20&%20Minifier%20v2.4.340.vsix"
Install-VSIX "CSS Tools" "a2b0e9a8-85c6-4495-8578-dc1da0a8791c/file/236630/3/CSS%20Tools%20v1.0.14.vsix"
Install-VSIX "Editor Enhancements" "4f64e542-3772-4136-8f87-0113441c7aa1/file/211002/13/Editor%20Enhancements%20v1.0.27.vsix"
Install-VSIX "File Icons" "5e1762e8-a88b-417c-8467-6a65d771cc4e/file/224554/26/File%20Icons%20v2.6.172.vsix"
Install-VSIX "HTML Tools" "0f48200f-ea7d-4e82-b366-45c1965768a7/file/236842/2/HTML%20Tools%20v1.0.3.vsix"
Install-VSIX "Project File Tools" "abcdb5ed-6cbc-4d2e-b1f7-7f184cfea89c/file/251340/2/ProjectFileTools.vsix"
Install-VSIX "Syntax Highlighting Pack" "d92fd742-bab3-4314-b866-50b871d679ee/file/225232/29/Syntax%20Highlighting%20Pack%20v2.6.118.vsix"
Install-VSIX "Web Accessibility Checker" "3aabefab-1681-4fea-8f95-6a62e2f0f1ec/file/207564/19/Web%20Accessibility%20Checker%20v1.4.47.vsix"
Install-VSIX "Web Compiler" "3b329021-cd7a-4a01-86fc-714c2d05bb6c/file/164873/42/Web%20Compiler%20v1.11.326.vsix"
Install-VSIX "Trailing Whitespace Visualizer" "a204e29b-1778-4dae-affd-209bea658a59/file/135653/35/Trailing%20Whitespace%20Visualizer%20v2.5.83.vsix"
Install-VSIX ".ignore" "d0eba56d-603b-45ab-a680-edfda585f7f3/file/212799/18/ignore%20v1.2.71.vsix"
Install-VSIX "EditorConfig Language Service" "a8c00bab-9ef3-47a4-8aaa-802d5cdb6ec0/file/233138/36/EditorConfig%20Language%20Service%20v1.17.202.vsix"

#### Productivity Power Tools 2017
Install-VSIX "Custom Document Well" "547d42c9-e08e-4fc0-b027-2ca506d4627a/file/242835/3/CustomDocWell.vsix"
Install-VSIX "Editor Guidelines" "72800f0b-3ebf-4afc-94f9-ab8aaed5c050/file/242845/6/EditorGuidelines.vsix"
Install-VSIX "Fix Mixed Tabs" "51e7a93b-5105-4bd5-8dfb-b95a0a701e66/file/242851/2/FixMixedTabs.vsix"
Install-VSIX "Shrink Empty Lines" "d265b256-6935-43b1-a5d7-25f28414a499/file/242914/4/ShrinkEmptyLines.vsix"
Install-VSIX "Solution Error Visualizer" "fcc4039b-b967-46c0-b7f4-97b539de9f45/file/242909/4/SolutionErrorVisualizer.vsix"

#### Others

Install-VSIX "VSColorOutput" "f4d9c2b5-d6d7-4543-a7a5-2d7ebabc2496/file/63103/18/VSColorOutput.vsix"
Install-VSIX "Region Expander" "2484a0ee-ed76-46d8-85e1-a0514d295b61/file/256415/1/RegionExpander.vsix"
Install-VSIX "Git Diff Margin" "cf49cf30-2ca6-4ea0-b7cc-6a8e0dadc1a8/file/101267/14/GitDiffMargin.vsix"
Install-VSIX "CodeMaid" "76293c4d-8c16-4f4a-aee6-21f83a571496/file/9356/38/CodeMaid%20v10.2.7.vsix"
Install-VSIX "SQLite / SQL Server Compact Toolbox" "0e313dfd-be80-4afb-b5e9-6e74d369f7a1/file/29445/85/SqlCeToolbox.4.5.0.3.vsix"
Install-VSIX "Visual StyleCop" "cac2a05b-6eb6-4fa2-95b9-1f8d011e6cae/file/173746/14/VSIXPackage.vsix"
Install-VSIX "SlowCheetah - XML Transforms" "/69023d00-a4f9-4a34-a6cd-7e854ba318b5/file/55948/27/SlowCheetah.VisualStudio.vsix"
Install-VSIX "PowerShell Tools for Visual Studio" "8389e80d-9e40-4fc1-907c-a07f7842edf2/file/257196/1/PowerShellTools.15.0.vsix"
Install-VSIX "GhostDoc" "46a20578-f0d5-4b1e-b55d-f001a6345748/file/5074/1/GhostDoc.v5.5.17070.VS2017.Extension.vsix"
Install-VSIX "ReAttach" "8cccc206-b9de-42ef-8f5a-160ad0f017ae/file/86492/14/ReAttach.vsix"
Install-VSIX "Disable No Source Available Tab" "fdbb2036-471e-40a7-b20e-31f8fd5578fa/file/39083/13/DisableNoSourceAvailableTab%20(2.0%20vs%202017%20support).vsix"
Install-VSIX "SpecFlow for Visual Studio 2017" "47ad86e2-d0a0-46f0-8746-ad7fe06df6b6/file/242540/3/TechTalk.SpecFlow.VsIntegration.2017-2017.1.6.vsix"
Install-VSIX "PerfWatson Monitor" "ad0897b3-7537-4c92-a38c-104b0e005206/file/75983/9/PerfWatsonMonitor.vsix"
