go projects

Push-Location choco-packages

Load-NuGetProfile choco

Get-ChildItem -Directory | foreach { 
    Push-Location $_.Name 
    choco-make-package.bat
    nuget-publish.bat *.nupkg
    Pop-Location
}

nuget-package-clean.bat
