$packageName = "mydev-buildserver"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try {
    setx.exe /M PATH "${env:PATH};C:\Program Files (x86)\Git\bin;C:\tools\apps\nuget"

    Write-ChocolateySuccess $packageName
} catch {
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
