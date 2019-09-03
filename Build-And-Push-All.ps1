gd code

Push-Location choco-packages

Load-NuGetProfile choco

Get-ChildItem -Directory | ForEach-Object {
    Write-Output $("------------ {0}" -f $_.Name)
    Push-Location $_.Name
    Remove-Item *.nupkg
    Make-ChocolateyPackage
    nuget-publish *.nupkg
    Pop-Location
}

nuget-package-clean
