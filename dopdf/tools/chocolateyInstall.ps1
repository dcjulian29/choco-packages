$packageName = "dopdf"
$installerType = "EXE"
$installerArgs = "/SILENT /NORESTART"
$url = "http://www.dopdf.com/download/setup/dopdf-7.exe"

try
{
    Install-ChocolateyPackage $packageName $installerType $installerArgs $url

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
