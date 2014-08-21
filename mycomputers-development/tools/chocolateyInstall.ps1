$packageName = "mycomputers-development"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try {
    $packages = @(
        "myscripts-development",
        "mydev-powershell",
        "mydev-scm",
        "mydev-visualstudio",
        "mydev-buildtools",
        "mydev-tools",
        "mydev-nodejs",
        "mydev-database")

    $devvmpackage = (Get-ChildItem "$($env:ChocolateyInstall)\lib" | Select-Object basename).basename `
        | Where-Object { $_.StartsWith("myvm-development") }

    if ($package.Count -gt 1) {
        Write-Warning "This package has already been installed, attempting to upgrade any dependent packages..."
        foreach ($package in $packages) {
            cup $package
        }
    } else {
        Write-Warning "This is the first time this package is install so assume no other packages have been installed..."
        foreach ($package in $packages) {
            cinst $package
        }
    }

    if (-not (Test-Path $env:SYSTEMDRIVE\home\projects))
    {
        New-Item -Type Directory -Path $env:SYSTEMDRIVE\home\projects | Out-Null
    }
  
    Write-ChocolateySuccess $packageName
} catch {
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
