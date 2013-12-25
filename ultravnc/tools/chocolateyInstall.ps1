$packageName = "ultravnc"
$installerType = "exe"
$installerArgs = "/SILENT"
$url = "http://support1.uvnc.com/download/1190/UltraVNC_1_1_9_X86_Setup.exe"
$url64 = "http://support1.uvnc.com/download/1190/UltraVNC_1_1_9_X64_Setup.exe"

try
{
    Install-ChocolateyPackage $packageName $installerType $installerArgs $url $url64

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
