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
        "mydev-python",
        "mydev-database")

    $devvmpackage = (Get-ChildItem "$($env:ChocolateyInstall)\lib" | Select-Object basename).basename `
        | Where-Object { $_.StartsWith("mycomputers-development") }

    if ($devvmpackage.Count -gt 1) {
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
    
    Import-Module "$env:USERPROFILE\Documents\WindowsPowerShell\Modules\go\go.psm1"

    go -Key "projects" -SelectedPath "${$env:SYSTEMDRIVE}\home\projects" -add
    go -Key "etc" -SelectedPath "${$env:SYSTEMDRIVE}\etc" -add
    go -Key "documents" -SelectedPath "${$env:USERPROFILE}\documents" -add
    go -Key "docs" -SelectedPath "${$env:USERPROFILE}\documents" -add
    go -Key "pictures" -SelectedPath "${$env:USERPROFILE}\pictures" -add
    go -Key "pics" -SelectedPath "${$env:USERPROFILE}\pictures" -add
    go -Key "videos" -SelectedPath "${$env:USERPROFILE}\videos" -add
    go -Key "desktop" -SelectedPath "${$env:USERPROFILE}\desktop" -add
    go -Key "downloads" -SelectedPath "${$env:USERPROFILE}\downloads" -add
    
    Write-ChocolateySuccess $packageName
} catch {
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
