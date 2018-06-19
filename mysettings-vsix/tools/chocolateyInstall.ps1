$packageName = "mysettings-vsix"
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
    "Installing $Name Extension from"
    "   $Url"

    $invalidChars = [IO.Path]::GetInvalidFileNameChars() -join ''
    $re = "[{0}]" -f [RegEx]::Escape($invalidChars)
    $Name = ($Name -replace $re)

    if (Test-Path "$downloadPath\$Name.vsix") {
        Remove-Item "$downloadPath\$Name.vsix" -Force
    }

    Download-File "$Url" "$downloadPath\$Name.vsix"

    Start-Process -FilePath $vsix -NoNewWindow -Wait `
        -ArgumentList "/quiet /logFile:""$downloadPath\$Name.log"" ""$downloadPath\$Name.vsix"""

    if (-not (Get-Content "$downloadPath\$Name.log" | Select-String -Pattern "Install to Visual Studio Enterprise 2017 completed successfully.")) {
        Write-Warning "An error occurred Installing $Name Extension..."
        Write-Warning "Review the log file: $logFile"
        throw
    }
}

#### Web Essentials 2017
Install-VSIX "Bundler & Minifier" "https://madskristensen.gallerycdn.vsassets.io/extensions/madskristensen/bundlerminifier/2.5.359/1505497807678/164487/44/Bundler%20&%20Minifier%20v2.5.359.vsix"
Install-VSIX "CSS Tools" "https://madskristensen.gallerycdn.vsassets.io/extensions/madskristensen/csstools/1.1.21/1508952904954/236630/5/CSS%20Tools%20v1.1.21.vsix"
Install-VSIX "Editor Enhancements" "https://madskristensen.gallerycdn.vsassets.io/extensions/madskristensen/editorenhancements/1.0.27/1482143277594/211002/13/Editor%20Enhancements%20v1.0.27.vsix"
Install-VSIX "File Icons" "https://madskristensen.gallerycdn.vsassets.io/extensions/madskristensen/fileicons/2.7.180/1494966904991/224554/27/File%20Icons%20v2.7.180.vsix"
Install-VSIX "HTML Tools" "https://madskristensen.gallerycdn.vsassets.io/extensions/madskristensen/htmltools/1.0.3/1482143974862/236842/2/HTML%20Tools%20v1.0.3.vsix"
Install-VSIX "Project File Tools" "https://ms-madsk.gallerycdn.vsassets.io/extensions/ms-madsk/projectfiletools/1.1.0/1502923205502/251340/3/ProjectFileTools.vsix"
Install-VSIX "Syntax Highlighting Pack" "https://madskristensen.gallerycdn.vsassets.io/extensions/madskristensen/syntaxhighlightingpack/2.7.125/1494972906146/225232/30/Syntax%20Highlighting%20Pack%20v2.7.125.vsix"
Install-VSIX "Web Compiler" "https://madskristensen.gallerycdn.vsassets.io/extensions/madskristensen/webcompiler/1.11.326/1482141920258/164873/42/Web%20Compiler%20v1.11.326.vsix"
Install-VSIX "Trailing Whitespace Visualizer" "https://madskristensen.gallerycdn.vsassets.io/extensions/madskristensen/trailingwhitespacevisualizer/2.5.83/1487866804225/135653/35/Trailing%20Whitespace%20Visualizer%20v2.5.83.vsix"
Install-VSIX ".ignore" "https://madskristensen.gallerycdn.vsassets.io/extensions/madskristensen/ignore/1.2.71/1482143287772/212799/18/ignore%20v1.2.71.vsix"
Install-VSIX "EditorConfig Language Service" "https://madskristensen.gallerycdn.vsassets.io/extensions/madskristensen/editorconfig/1.17.230/1513357984540/editorconfig.vsix"

#### Productivity Power Tools 2017
Install-VSIX "Custom Document Well" "https://visualstudioproductteam.gallerycdn.vsassets.io/extensions/visualstudioproductteam/customdocumentwell/15.0.4/1492133109751/242835/6/CustomDocWell.vsix"
Install-VSIX "Editor Guidelines" "https://visualstudioproductteam.gallerycdn.vsassets.io/extensions/visualstudioproductteam/editorguidelines/15.0.4/1514397356063/242845/6/EditorGuidelines.vsix"
Install-VSIX "Fix Mixed Tabs" "https://visualstudioproductteam.gallerycdn.vsassets.io/extensions/visualstudioproductteam/fixmixedtabs/15.0.3/1492133419585/242851/5/FixMixedTabs.vsix"
Install-VSIX "Shrink Empty Lines" "https://visualstudioproductteam.gallerycdn.vsassets.io/extensions/visualstudioproductteam/syntacticlinecompression/15.0.5/1492133133449/242914/8/ShrinkEmptylines.vsix"
Install-VSIX "Solution Error Visualizer" "https://visualstudioproductteam.gallerycdn.vsassets.io/extensions/visualstudioproductteam/solutionerrorvisualizer/15.0.4/1492133129068/242909/7/SolutionErrorFilter.vsix"

#### Others
Install-VSIX "VSColorOutput" "https://mikeward-annarbor.gallerycdn.vsassets.io/extensions/mikeward-annarbor/vscoloroutput/2.5.1/1496590205528/63103/21/VSColorOutput.vsix"
Install-VSIX "Region Expander" "https://davidperfors.gallerycdn.vsassets.io/extensions/davidperfors/regionexpander/0.3/1491502202573/256415/2/RegionExpander.vsix"
Install-VSIX "Git Diff Margin" "https://laurentkempe.gallerycdn.vsassets.io/extensions/laurentkempe/gitdiffmargin/3.6.0.69/1512507764849/GitDiffMargin.vsix"
Install-VSIX "CodeMaid" "https://stevecadwallader.gallerycdn.vsassets.io/extensions/stevecadwallader/codemaid/10.4.53/1495281311811/9356/40/CodeMaid%20v10.4.53.vsix"
Install-VSIX "SQLite / SQL Server Compact Toolbox" "https://erikej.gallerycdn.vsassets.io/extensions/erikej/sqlservercompactsqlitetoolbox/4.7.427/1510402820586/29445/97/SqlCeVsToolbox.4.7.427.vsix"
Install-VSIX "StyleCop" "https://chrisdahlberg.gallerycdn.vsassets.io/extensions/chrisdahlberg/stylecop/5.0.6419.0/1501345807969/231103/4/StyleCop.vsix"
Install-VSIX "SlowCheetah - XML Transforms" "https://visualstudioproductteam.gallerycdn.vsassets.io/extensions/visualstudioproductteam/slowcheetah-xmltransforms/3.0.61.18192/1504804805782/55948/29/Microsoft.VisualStudio.SlowCheetah.vsix"
Install-VSIX "GhostDoc" "https://sergeb.gallerycdn.vsassets.io/extensions/sergeb/ghostdoc/5.8.17335/1512671123261/5074/6/GhostDoc.v5.8.17335.VS2017.Extension.vsix"
Install-VSIX "ReAttach" "https://erlandr.gallerycdn.vsassets.io/extensions/erlandr/reattach/2.2/1490598305903/86492/14/ReAttach.vsix"
Install-VSIX "Disable No Source Available Tab" "https://mayerwin.gallerycdn.vsassets.io/extensions/mayerwin/disablenosourceavailabletab/2.0/1488372019971/39083/13/DisableNoSourceAvailableTab%20(2.0%20vs%202017%20support).vsix"
Install-VSIX "PerfWatson Monitor" "https://paulharrington.gallerycdn.vsassets.io/extensions/paulharrington/perfwatsonmonitor-9621/11.17.414.0/1492179304031/75983/9/PerfWatsonMonitor.vsix"
Install-VSIX "Roslyn Security Guard" "https://philippearteau.gallerycdn.vsassets.io/extensions/philippearteau/roslynsecurityguard/2.3.0/1499148905608/232680/3/RoslynSecurityGuard.Vsix.vsix"
Install-VSIX "Puma Scan" "https://pumasecurity.gallerycdn.vsassets.io/extensions/pumasecurity/pumascan/1.0.6/1501039205850/230031/7/Puma.Security.Rules.Vsix.1.0.6.vsix"
Install-VSIX "SonarLint for Visual Studio 2017" "https://sonarsource.gallerycdn.vsassets.io/extensions/sonarsource/sonarlintforvisualstudio2017/4.0.0.3479/1525365347294/SonarLint.VSIX-4.0.0.3479-2017.vsix"


Install-VSIX "Hot Source" "https://justinclareburtmsft.gallerycdn.vsassets.io/extensions/justinclareburtmsft/hotsource/0.1.2/1526810909635/HotSource.vsix"
Install-VSIX "Whack Whack Terminal" "https://danielgriffen.gallerycdn.vsassets.io/extensions/danielgriffen/whackwhackterminal/1.0.14.35683/1520634760590/WhackWhackTerminal.vsix"

