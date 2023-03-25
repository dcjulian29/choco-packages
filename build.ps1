trap [System.Exception] {
  "Exception: {0}" -f $_.Exception.Message
  [Environment]::Exit(1)
}

$ErrorActionPreference = "Stop"
$baseDir = (Resolve-Path $("$PSScriptRoot")).Path
$packDir = Join-Path -Path $baseDir -ChildPath ".packages"
$toolDir = Join-Path -Path $baseDir -ChildPath ".tools"

if (-not (Test-Path $packDir)) {
  New-Item -Path $packDir -ItemType Directory | Out-Null
}

if (Get-Command -Name "nuget") {
  $nuget = (Get-Command -Name "nuget").Source
} else {
  $nuget = Join-Path -Path $TOOLS_DIR -ChildPath "nuget.exe"

  if (-not (Test-Path -Path $nuget)) {
    if (-not (Test-Path $toolDir)) {
      New-Item -Path $TOOLS_DIR -Type Directory | Out-Null
    }

    Invoke-WebRequest -Uri "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe" `
      -OutFile $nuget
  }
}

#------------------------------------------------------------------------------

Get-ChildItem -Path $baseDir -Directory | ForEach-Object {
  Push-Location $(Join-Path -Path $baseDir -ChildPath $_.Name)

  if (Test-Path "Package.nuspec") {
    $al = @(
      "pack"
      "Package.nuspec"
      "-OutputDirectory $packDir"
      "-Verbosity detailed"
      "-NoPackageAnalysis"
      "-NonInteractive"
      "-NoDefaultExcludes"
    )

    Start-Process -FilePath $nuget -ArgumentList $al -NoNewWindow -Wait
  }

  Pop-Location
}