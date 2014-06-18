$packageName = "java"
$installerType = "exe"
$installerArgs = "/s REBOOT=Suppress WEB_JAVA=0"

$url = "http://download.oracle.com/otn-pub/java/jdk/7u60-b19/jre-7u60-windows-i586.exe"
$url64 = "http://download.oracle.com/otn-pub/java/jdk/7u60-b19/jre-7u60-windows-x64.exe"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

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
