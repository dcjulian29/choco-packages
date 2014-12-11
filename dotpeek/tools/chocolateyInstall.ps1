$packageName = "dotpeek"
$installerType = "EXE"
$installerArgs = "/qn"
$url = "http://download.jetbrains.com/resharper/dotPeek32_1.3.exe"
$url64 = "http://download.jetbrains.com/resharper/dotPeek64_1.3.exe"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

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
