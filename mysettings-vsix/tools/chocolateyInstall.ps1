$downloadPath = "$env:TEMP\vsix"
$errorInstalling = $false
$vsix = Find-VSIX


if (Test-Path $downloadPath) {
    Remove-Item -Path $downloadPath -Recurse -Force
}

New-Item -Type Directory -Path $downloadPath | Out-Null

Function Install-VSIX {
    param (
        [string]$Name,
        [string]$Url
    )

    $originalErrorAction = $ErrorActionPreference

    $ErrorActionPreference = 'Stop'

    $invalidChars = [IO.Path]::GetInvalidFileNameChars() -join ''
    $re = "[{0} ]" -f [RegEx]::Escape($invalidChars)

    $baseName = ($Name -replace $re)

    $logFile = "$downloadPath\{0}_{1:yyyyMMddHHmmss}.log" -f $baseName, (Get-Date)
    $vsixFile = "$downloadPath\$baseName.vsix"

    " "
    "=========================================================="
    " "
    "Installing $Name Extension from"
    "   $Url"
    " "
    "    VSIX File: $vsixFile"
    "    Log File: $logFile"
    " "

    try {
        if (Test-Path $vsixFile) {
            Remove-Item $vsixFile -Force
        }

        Download-File $Url $vsixFile

        $arguments = @(
            "/quiet"
            "/logFile:$logFile"
            "$vsixFile"
        )

        $run = Start-Process -FilePath $vsix -ArgumentList $arguments -PassThru -Wait -NoNewWindow -Verbose

        $exitCode = [Int32]$run.ExitCode

        if ($exitCode -eq 1001) {
            Write-Host "INFORMATION: The $Name Extension is already installed." -ForegroundColor Magenta
        } else {
            if ($exitCode -gt 0) {
                " "
                Write-Host "An error occurred installing $Name Extension..." -ForegroundColor Magenta
                Write-Host "Exit Code: *$exitCode*" -ForegroundColor Magenta
                Write-Host "Review the log file: $logFile" -ForegroundColor Magenta
                $errorInstalling = $true
            }
        }
    } catch {
        $errorMessage = $_.Exception.Message
        Write-Host " "
        Write-Host "An error occurred during installation of the $Name Extension..." -ForegroundColor Magenta
        Write-Host "Error: $errorMessage" -ForegroundColor Magenta
        Write-Host "Review the log file: $logFile" -ForegroundColor Magenta
        $errorInstalling = $true
    }

    $ErrorActionPreference = $originalErrorAction
}

#### Core Web Essentials
Install-VSIX "Bundler & Minifier" "https://madskristensen.gallerycdn.vsassets.io/extensions/madskristensen/bundlerminifier/2.8.396/1535134367605/Bundler___Minifier_v2.8.396.vsix"
Install-VSIX "CSS Tools" "https://madskristensen.gallerycdn.vsassets.io/extensions/madskristensen/csstools2019/1.1.2/1553187100196/CSS_Tools_2019_v1.1.2.vsix"
Install-VSIX "Editor Enhancements" "https://madskristensen.gallerycdn.vsassets.io/extensions/madskristensen/editorenhancements/1.0.30/1535134387263/Editor_Enhancements_v1.0.30.vsix"
Install-VSIX "File Icons" "https://madskristensen.gallerycdn.vsassets.io/extensions/madskristensen/fileicons/2.7.228/1551463426680/File_Icons_v2.7.228.vsix"
Install-VSIX "Markdown Editor" "https://madskristensen.gallerycdn.vsassets.io/extensions/madskristensen/markdowneditor/1.12.236/1535134643679/Markdown_Editor_v1.12.236.vsix"
Install-VSIX "Package Security Alerts" "https://madskristensen.gallerycdn.vsassets.io/extensions/madskristensen/packagesecurityalerts/1.0.22/1536787178851/Package_Security_Alerts_v1.0.22.vsix"
Install-VSIX "Syntax Highlighting Pack" "https://madskristensen.gallerycdn.vsassets.io/extensions/madskristensen/syntaxhighlightingpack/2.8.134/1536785834762/Syntax_Highlighting_Pack_v2.8.134.vsix"
Install-VSIX "Web Accessibility Checker" "https://madskristensen.gallerycdn.vsassets.io/extensions/madskristensen/webaccessibilitychecker/1.5.58/1535134672243/Web_Accessibility_Checker_v1.5.58.vsix"
Install-VSIX "Web Compiler" "https://madskristensen.gallerycdn.vsassets.io/extensions/madskristensen/webcompiler/1.12.394/1538582164333/Web_Compiler_v1.12.394.vsix"

#### Other Mads Kristensen Extentions
Install-VSIX ".ignore" "https://madskristensen.gallerycdn.vsassets.io/extensions/madskristensen/ignore/1.2.77/1535142107247/.ignore_v1.2.77.vsix"
Install-VSIX "Trailing Whitespace Visualizer" "https://madskristensen.gallerycdn.vsassets.io/extensions/madskristensen/trailingwhitespacevisualizer/2.5.93/1544213674964/Trailing_Whitespace_Visualizer_v2.5.93.vsix"
Install-VSIX "EditorConfig Language Service" "https://madskristensen.gallerycdn.vsassets.io/extensions/madskristensen/editorconfig/1.17.258/1552490541253/EditorConfig_Language_Service_v1.17.258.vsix"

#### Productivity Power Tools
Install-VSIX "Fix Mixed Tabs" "https://visualstudioplatformteam.gallerycdn.vsassets.io/extensions/visualstudioplatformteam/fixmixedtabs/15.0.6/1553638217769/FixMixedTabs.vsix"
Install-VSIX "Shrink Empty Lines" "https://visualstudioplatformteam.gallerycdn.vsassets.io/extensions/visualstudioplatformteam/syntacticlinecompression/15.0.7/1543238149040/SyntacticLineCompression.vsix"
Install-VSIX "Solution Error Visualizer" "https://visualstudioplatformteam.gallerycdn.vsassets.io/extensions/visualstudioplatformteam/solutionerrorvisualizer/15.0.4/1543238152087/SolutionErrorFilter.vsix"

#### Others
Install-VSIX "VSColorOutput" "https://mikeward-annarbor.gallerycdn.vsassets.io/extensions/mikeward-annarbor/vscoloroutput/2.6.4/1548094340477/VSColorOutput.vsix"
Install-VSIX "Region Expander" "https://davidperfors.gallerycdn.vsassets.io/extensions/davidperfors/regionexpander/0.5/1543951484486/RegionExpander.vsix"
Install-VSIX "Git Diff Margin" "https://laurentkempe.gallerycdn.vsassets.io/extensions/laurentkempe/gitdiffmargin/3.9.4.73/1552425425998/GitDiffMargin.vsix"
Install-VSIX "CodeMaid" "https://stevecadwallader.gallerycdn.vsassets.io/extensions/stevecadwallader/codemaid/11.0.183/1553341607616/CodeMaid_v11.0.183.vsix"
Install-VSIX "SQLite / SQL Server Compact Toolbox" "https://erikej.gallerycdn.vsassets.io/extensions/erikej/sqlservercompactsqlitetoolbox/4.7.634/1549801715905/SqlCeVsToolbox.4.7.634.vsix"
#Install-VSIX "StyleCop" "https://chrisdahlberg.gallerycdn.vsassets.io/extensions/chrisdahlberg/stylecop/5.0.6419.0/1501345807969/231103/4/StyleCop.vsix"
Install-VSIX "SlowCheetah" "https://vscps.gallerycdn.vsassets.io/extensions/vscps/slowcheetah-xmltransforms/3.2.18.4433/1547757608353/Microsoft.VisualStudio.SlowCheetah.vsix"
#Install-VSIX "GhostDoc" "https://sergeb.gallerycdn.vsassets.io/extensions/sergeb/ghostdoc/5.9.18070/1520626062408/GhostDoc.v5.9.18070.VS2017.Extension.vsix"
#Install-VSIX "ReAttach" "https://erlandr.gallerycdn.vsassets.io/extensions/erlandr/reattach/2.2/1490598305903/86492/14/ReAttach.vsix"
Install-VSIX "Disable No Source Available Tab" "https://mayerwin.gallerycdn.vsassets.io/extensions/mayerwin/disablenosourceavailabletab/3.2/1552895908582/DisableNoSourceAvailableTab__3.2_.vsix"
Install-VSIX "PerfWatson Monitor" "https://paulharrington.gallerycdn.vsassets.io/extensions/paulharrington/perfwatsonmonitor-9621/12.0.0/1553664190479/PerfWatsonMonitor.vsix"
#Install-VSIX "Roslyn Security Guard" "https://philippearteau.gallerycdn.vsassets.io/extensions/philippearteau/roslynsecurityguard/2.3.0/1519069597068/232680/3/RoslynSecurityGuard.Vsix.vsix"
Install-VSIX "Puma Scan" "https://pumasecurity.gallerycdn.vsassets.io/extensions/pumasecurity/pumascan/2.1.0.0/1553877086038/Puma.Security.Rules.Vsix.2.1.0.0.vsix"
Install-VSIX "SonarLint" "https://sonarsource.gallerycdn.vsassets.io/extensions/sonarsource/sonarlintforvisualstudio2019/4.9.0.4316/1554460936213/SonarLint.VSIX-4.9.0.4316-2019.vsix"
Install-VSIX "Visual Studio Spell Checker" "https://ewoodruff.gallerycdn.vsassets.io/extensions/ewoodruff/visualstudiospellcheckervs2017andlater/2018.10.27.0/1540682853066/VisualStudio.SpellChecker.VS2017AndLater.vsix"

if ($errorInstalling) {
    Write-Error "An Error occurred installing one of the VSIX extentions. Review the log file..."
    throw
}
