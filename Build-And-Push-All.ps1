go projects

Push-Location choco-packages

Load-NuGetProfile choco

Get-ChildItem -Directory | foreach { 
    Push-Location $_.Name 
    Remove-Item *.nupkg
    Make-ChocolateyPackage
    nuget-publish *.nupkg
    Pop-Location
}

nuget-package-clean
