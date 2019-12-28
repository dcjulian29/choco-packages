gd code

Push-Location choco-packages

Get-ChildItem -Directory | ForEach-Object {
    Write-Output $("------------ {0}" -f $_.Name)
    Push-Location $_.Name
    Remove-Item *.nupkg
    Make-ChocolateyPackage
    Pop-Location
}
