$script:downloadSession = $null

function installVsixByName($name) {
  $baseURL = "https://marketplace.visualstudio.com"
  $url = "$baseURL/items?itemName=$Name"
  $href = ""

  try {
    $html = Invoke-WebRequest -Uri $url -UseBasicParsing `
      -SessionVariable 'Session' -ErrorAction SilentlyContinue

    if ($html.StatusCode -ne 200) {
      throw "An error occurred determining download URL (StatusCode: $statusCode)."
    }

    $anchor = $html.Links |
    Where-Object { $_.class -eq 'install-button-container' } |
    Select-Object -ExpandProperty href

    if (-not $anchor) {
      throw "Could not determine download URL on the Visual Studio Extensions page."
    }

    $script:downloadSession = $Session

    $href = "$baseURL/$anchor"
  }
  catch {
    throw $_.Exception.Message
  }

  $file = "${env:TEMP}\$([Guid]::NewGuid()).vsix"

  Invoke-WebRequest $href -OutFile $file -WebSession $script:downloadSession

  if (Test-Path $file) {
    installVsixPackage $Name $file
  }
  else {
    throw "The VSIX file could not be downloaded."
  }
}

function installVsixPackage($Name, $Path) {
  $vsix = 'C:\Program Files\' `
    + 'Microsoft Visual Studio\18\Professional\Common7\IDE\VSIXInstaller.exe'

  if (-not ($vsix)) {
    throw "The VSIX installer was not found."
  }

  $invalidChars = [IO.Path]::GetInvalidFileNameChars() -join ''
  $re = "[{0} ]" -f [RegEx]::Escape($invalidChars)
  $date = Get-Date -Format "yyyyMMdd_HHmmss"

  $tempLog = "{1}-vsix-{0}.log" -f ($Name -replace $re), $date
  $logFile = "${env:TEMP}\{1}-vsix-{0}.log" -f ($Name -replace $re), $date
  $vsixFile = (Resolve-Path $Path | Get-Item).FullName

  Write-Output "- VSIX File: $vsixFile"
  Write-Output "-  Log File: $logFile"

  try {
    $arguments = @(
      "/quiet"
      "/logFile:$tempLog"
      "$vsixFile")

    $run = Start-Process -FilePath $vsix -ArgumentList $arguments -PassThru -Wait -NoNewWindow
    $exitCode = [Int32]$run.ExitCode

    Move-Item -Path "${env:TEMP}\$tempLog" -Destination $logFile

    switch ($exitCode) {
      1001 {
        Write-Warning "The '$Name' Extension is already installed."
      }

      2003 {
        Write-Warning "The '$Name' Extension isn't compatible with any installed SKUs."
      }

      default {
        if ($exitCode -gt 0) {
          throw "An error occurred during installation of '$Name' ($exitCode)"
        }

        $t = "Install to Visual Studio \w+\s\d+\scompleted successfully"

        if ((Test-Path $logFile) -and (-not (Get-Content $logFile | Select-String -Pattern $t))) {
          throw "An error occurred during installation of the $Name Extension."
        }
      }
    }
  }
  catch {
    Write-Output "`n`n~~~~`nAn error occurred during installation of the $Name Extension..."

    throw "Error: $($_.Exception.Message) ($exitCode)" `
  }
}

function installPackages($packages) {
  foreach ($package in $packages) {
    Write-Output "  "
    Write-Output "---------- $package"
    installVsixByName $package
  }
}

Write-Output "Installing Visual Studio Workloads..."

@(
  "visualstudio2026-workload-manageddesktop"
  "visualstudio2026-workload-netweb"
) | ForEach-Object {
  choco install -y $_
}

Write-Output "Installing VSIX Extensions..."

# Popular VSIX
installPackages @(
  "MadsKristensen.FileIcons"
  "NikolayBalakin.Outputenhancer"
  "LaurentKempe.GitDiffMargin"
  "MadsKristensen.MarkdownEditor2"
  "ErlandR.ReAttach"
  "PaulHarrington.EditorGuidelinesPreview"
  "MadsKristensen.TrailingWhitespace64"
  "AndreasReischuck.SemanticColorizer"
  "SergeyVlasov.FixFileEncoding"
  "MadsKristensen.Tweaks2022"
  "VisualStudioPlatformTeam.FixMixedTabs2022"
)

# Other VSIX
installPackages @(
  "EWoodruff.VisualStudioSpellCheckerVS2022andLater"
  "idex.vsthemepack"
  "VisualStudioPlatformTeam.SyntacticLineCompression2022"
  "FortuneNgwenya.FineCodeCoverage2022"
  "MikeWard-AnnArbor.VSColorOutput64"
  "TimHeuer.GitHubActionsVS"
)

# CSharp VSIX
installPackages @(
  "josefpihrt.Roslynator2022"
  "jsakamoto.CMethodsCodeSnippets"
  "LBHSR.ParallelChecker"
  "MattLaceyLtd.WarnAboutTODOs"
  "PumaSecurity.PumaScan2022"
  "RandomEngy.UnitTestBoilerplateGenerator"
  "sergeb.GhostDoc"
  "SonarSource.SonarLintforVisualStudio2022"
  "SteveCadwallader.CodeMaidVS2022"
  "TomEnglert.Wax"
)

# Web VSIX
installPackages @(
  "MadsKristensen.EditorEnhancements64"
  "MadsKristensen.HTMLSnippetPack"
  "MadsKristensen.JavaScriptSnippetPack"
)
