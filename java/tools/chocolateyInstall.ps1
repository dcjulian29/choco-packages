$packageName = "java"
$installerType = "exe"
$installerArgs = "/s REBOOT=Suppress WEB_JAVA=0"
$url = "http://javadl.sun.com/webapps/download/AutoDL?BundleId=86895"
$url64 = "http://javadl.sun.com/webapps/download/AutoDL?BundleId=87443"

try {	
    Install-ChocolateyPackage $packageName $installerType $installerArgs $url
  
    $path = Join-Path $env:ProgramFiles "Java\jre7"
    
    if ((Get-WmiObject Win32_Processor).AddressWidth -eq 64) { 
        Install-ChocolateyPackage $packageName $installerType $installerArgs $url64
        $path = Join-Path $env:ProgramW6432 "Java\jre7"
    }

    Start-ChocolateyProcessAsAdmin `
        "[Environment]::SetEnvironmentVariable('JAVA_HOME','$path', 'Machine')"

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
