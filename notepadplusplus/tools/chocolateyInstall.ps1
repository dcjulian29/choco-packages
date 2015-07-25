$packageName = "notepadplusplus"
$installerType = "EXE"
$installerArgs = "/S"
$url = "https://notepad-plus-plus.org/repository/6.x/6.8/npp.6.8.Installer.exe"

try {
    Install-ChocolateyPackage $packageName $installerType $installerArgs $url

    Write-ChocolateySuccess $packageName
} catch {
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
