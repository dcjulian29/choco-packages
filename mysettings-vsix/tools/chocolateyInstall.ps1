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

$vsix = "$vsix\Microsoft Visual Studio\2017\Professional\Common7\IDE\VSIXInstaller.exe"

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

    if (-not (Get-Content "$downloadPath\$Name.log" | Select-String -Pattern "Install to Visual Studio Professional 2017 completed successfully.")) {
        Write-Warning "An error occurred Installing $Name Extension..."
        Write-Warning "Review the log file: $logFile"
        throw
    }
}

#### Web Essentials 2017
Install-VSIX "Bundler & Minifier" "https://madskristensen.gallerycdn.vsassets.io/extensions/madskristensen/bundlerminifier/2.8.396/1535134367605/Bundler___Minifier_v2.8.396.vsix"
Install-VSIX "CSS Tools" "https://madskristensen.gallerycdn.vsassets.io/extensions/madskristensen/csstools/1.1.23/1534434064085/CSS_Tools_v1.1.23.vsix"
Install-VSIX "Editor Enhancements" "https://madskristensen.gallerycdn.vsassets.io/extensions/madskristensen/editorenhancements/1.0.30/1535134387263/Editor_Enhancements_v1.0.30.vsix"
Install-VSIX "File Icons" "https://madskristensen.gallerycdn.vsassets.io/extensions/madskristensen/fileicons/2.7.222/1536178942711/File_Icons_v2.7.222.vsix"
Install-VSIX "HTML Tools" "https://madskristensen.gallerycdn.vsassets.io/extensions/madskristensen/htmltools/1.0.3/1482143974862/236842/2/HTML%20Tools%20v1.0.3.vsix"
Install-VSIX "Project File Tools" "https://ms-madsk.gallerycdn.vsassets.io/extensions/ms-madsk/projectfiletools/1.3.1/1537564617139/ProjectFileTools.vsix"
Install-VSIX "Syntax Highlighting Pack" "https://madskristensen.gallerycdn.vsassets.io/extensions/madskristensen/syntaxhighlightingpack/2.8.134/1536785834762/Syntax_Highlighting_Pack_v2.8.134.vsix"
Install-VSIX "Web Compiler" "https://madskristensen.gallerycdn.vsassets.io/extensions/madskristensen/webcompiler/1.11.326/1482141920258/164873/42/Web%20Compiler%20v1.11.326.vsix"
Install-VSIX "Trailing Whitespace Visualizer" "https://madskristensen.gallerycdn.vsassets.io/extensions/madskristensen/trailingwhitespacevisualizer/2.5.90/1535142616954/Trailing_Whitespace_Visualizer_v2.5.90.vsix"
Install-VSIX ".ignore" "https://madskristensen.gallerycdn.vsassets.io/extensions/madskristensen/ignore/1.2.77/1535142107247/.ignore_v1.2.77.vsix"
Install-VSIX "EditorConfig Language Service" "https://madskristensen.gallerycdn.vsassets.io/extensions/madskristensen/editorenhancements/1.0.30/1535134387263/Editor_Enhancements_v1.0.30.vsix"
Install-VSIX "Web Accessibility Checker" "https://madskristensen.gallerycdn.vsassets.io/extensions/madskristensen/webaccessibilitychecker/1.5.58/1535134672243/Web_Accessibility_Checker_v1.5.58.vsix"
Install-VSIX "Package Security Alerts" "https://madskristensen.gallerycdn.vsassets.io/extensions/madskristensen/packagesecurityalerts/1.0.22/1536787178851/Package_Security_Alerts_v1.0.22.vsix"
Install-VSIX "Markdown Editor" "https://madskristensen.gallerycdn.vsassets.io/extensions/madskristensen/markdowneditor/1.12.236/1535134643679/Markdown_Editor_v1.12.236.vsix"
Install-VSIX "Vue.js Pack" "https://madskristensen.gallerycdn.vsassets.io/extensions/madskristensen/vuejspack-18329/1.1.8/1490717404120/250225/5/Vue.js%20Pack%202017%20v1.1.8.vsix"
Install-VSIX "Image Sprites" "https://madskristensen.gallerycdn.vsassets.io/extensions/madskristensen/imagesprites/1.4.58/1535134613204/Image_Sprites_v1.4.58.vsix"
Install-VSIX "CSS Sorter" "https://madskristensen.gallerycdn.vsassets.io/extensions/madskristensen/csssorter/0.8.7/1538079473632/CSS_Sorter_v0.8.7.vsix"

#### Productivity Power Tools 2017
Install-VSIX "Custom Document Well" "https://visualstudioplatformteam.gallerycdn.vsassets.io/extensions/visualstudioplatformteam/customdocumentwell/15.0.4/1517829822936/242835/6/CustomDocWell.vsix"
Install-VSIX "Editor Guidelines" "https://visualstudioproductteam.gallerycdn.vsassets.io/extensions/visualstudioproductteam/editorguidelines/15.0.4/1514397356063/242845/6/EditorGuidelines.vsix"
Install-VSIX "Fix Mixed Tabs" "https://visualstudioproductteam.gallerycdn.vsassets.io/extensions/visualstudioproductteam/fixmixedtabs/15.0.3/1492133419585/242851/5/FixMixedTabs.vsix"
Install-VSIX "Shrink Empty Lines" "https://visualstudioproductteam.gallerycdn.vsassets.io/extensions/visualstudioproductteam/syntacticlinecompression/15.0.5/1492133133449/242914/8/ShrinkEmptylines.vsix"
Install-VSIX "Solution Error Visualizer" "https://visualstudioproductteam.gallerycdn.vsassets.io/extensions/visualstudioproductteam/solutionerrorvisualizer/15.0.4/1492133129068/242909/7/SolutionErrorFilter.vsix"

#### Others
Install-VSIX "VSColorOutput" "https://mikeward-annarbor.gallerycdn.vsassets.io/extensions/mikeward-annarbor/vscoloroutput/2.5.1/1496590205528/63103/21/VSColorOutput.vsix"
Install-VSIX "Region Expander" "https://davidperfors.gallerycdn.vsassets.io/extensions/davidperfors/regionexpander/0.4/1521454529241/RegionExpander.vsix"
Install-VSIX "Git Diff Margin" "https://laurentkempe.gallerycdn.vsassets.io/extensions/laurentkempe/gitdiffmargin/3.8.1.163/1535476221415/GitDiffMargin.vsix"
Install-VSIX "CodeMaid" "https://stevecadwallader.gallerycdn.vsassets.io/extensions/stevecadwallader/codemaid/10.5.119/1528571016929/CodeMaid_v10.5.119.vsix"
Install-VSIX "SQLite / SQL Server Compact Toolbox" "https://erikej.gallerycdn.vsassets.io/extensions/erikej/sqlservercompactsqlitetoolbox/4.7.534/1518354313794/SqlCeVsToolbox.4.7.534.vsix"
Install-VSIX "StyleCop" "https://chrisdahlberg.gallerycdn.vsassets.io/extensions/chrisdahlberg/stylecop/5.0.6419.0/1501345807969/231103/4/StyleCop.vsix"
Install-VSIX "SlowCheetah" "https://vscps.gallerycdn.vsassets.io/extensions/vscps/slowcheetah-xmltransforms/3.1.69.25612/1531957598091/Microsoft.VisualStudio.SlowCheetah.vsix"
Install-VSIX "GhostDoc" "https://sergeb.gallerycdn.vsassets.io/extensions/sergeb/ghostdoc/5.9.18070/1520626062408/GhostDoc.v5.9.18070.VS2017.Extension.vsix"
Install-VSIX "ReAttach" "https://erlandr.gallerycdn.vsassets.io/extensions/erlandr/reattach/2.2/1490598305903/86492/14/ReAttach.vsix"
Install-VSIX "Disable No Source Available Tab" "https://mayerwin.gallerycdn.vsassets.io/extensions/mayerwin/disablenosourceavailabletab/2.0/1488372019971/39083/13/DisableNoSourceAvailableTab%20(2.0%20vs%202017%20support).vsix"
Install-VSIX "PerfWatson Monitor" "https://paulharrington.gallerycdn.vsassets.io/extensions/paulharrington/perfwatsonmonitor-9621/11.17.414.0/1492179304031/75983/9/PerfWatsonMonitor.vsix"
Install-VSIX "Roslyn Security Guard" "https://philippearteau.gallerycdn.vsassets.io/extensions/philippearteau/roslynsecurityguard/2.3.0/1519069597068/232680/3/RoslynSecurityGuard.Vsix.vsix"
Install-VSIX "Puma Scan" "https://pumasecurity.gallerycdn.vsassets.io/extensions/pumasecurity/pumascan/2.0.0.1/1533875976755/Puma.Security.Rules.Vsix.2.0.0.1.vsix"
Install-VSIX "SonarLint" "https://sonarsource.gallerycdn.vsassets.io/extensions/sonarsource/sonarlintforvisualstudio2017/4.4.0.3745/1536052203864/SonarLint.VSIX-4.4.0.3745-2017.vsix"
Install-VSIX "Whack Whack Terminal" "https://danielgriffen.gallerycdn.vsassets.io/extensions/danielgriffen/whackwhackterminal/1.1.3.25906/1530136152443/WhackWhackTerminal.vsix"
Install-VSIX "Visual Studio IntelliCode" "https://visualstudioexptteam.gallerycdn.vsassets.io/extensions/visualstudioexptteam/vsintellicode/1.3.8.60621/1536614597513/Microsoft.VisualStudio.IntelliCode.vsix"
Install-VSIX "Visual Studio Spell Checker" "https://ewoodruff.gallerycdn.vsassets.io/extensions/ewoodruff/visualstudiospellcheckervs2017andlater/2018.8.25.0/1535239788431/VisualStudio.SpellChecker.VS2017AndLater.vsix"