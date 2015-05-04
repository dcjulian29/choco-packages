$packageName = "notepadplusplus"
$installerType = "EXE"
$installerArgs = "/S"
$url = "http://notepad-plus-plus.org/repository/6.x/6.7.7/npp.6.7.7.Installer.exe"

try {
    Install-ChocolateyPackage $packageName $installerType $installerArgs $url

    Write-ChocolateySuccess $packageName
} catch {
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
