trap [System.Exception] {
  "Exception: {0}" -f $_.Exception.Message
  [Environment]::Exit(1)
}

$ErrorActionPreference = "Stop"
$baseDir = (Resolve-Path $("$PSScriptRoot")).Path
$toolDir = Join-Path -Path $baseDir -ChildPath ".tools"

if (Get-Command -Name "nuget") {
  $nuget = (Get-Command -Name "nuget").Source
} else {
  $nuget = Join-Path -Path $toolDir -ChildPath "nuget.exe"

  if (-not (Test-Path -Path $nuget)) {
    if (-not (Test-Path $toolDir)) {
      New-Item -Path $toolDir -Type Directory | Out-Null
    }

    Invoke-WebRequest -Uri "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe" `
      -OutFile $nuget
  }
}

$packDir = Join-Path -Path $baseDir -ChildPath ".packages"

if (-not (Test-Path $packDir)) {
  New-Item -Path $packDir -ItemType Directory | Out-Null
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

    $p = Start-Process -FilePath $nuget -ArgumentList $al -NoNewWindow -Wait -PassThru

    Pop-Location

    if ($p.ExitCode -ne 0) {
      throw "Failure creating package '$($_.BaseName)' with status code $($p.ExitCode)"
    }
  }
}
