$packageName = "msbuild"
$installerType = "EXE"
$installerArgs = "/passive /norestart"
$url = "http://download.microsoft.com/download/9/B/B/9BB1309E-1A8F-4A47-A6C5-ECF76672A3B3/BuildTools_Full.exe"
$toolDir = "$(Split-Path -parent $MyInvocation.MyCommand.Path)"
$contentDir = "$(Split-Path -parent $toolDir)\content"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try
{
    Install-ChocolateyPackage $packageName $installerType $installerArgs $url $url

    if (Test-Path "C:\Program Files\MSBuild") {
        $msbuild = "C:\Program Files\MSBuild"
    }

    if (Test-Path "C:\Program Files (x86)\MSBuild") {
        $msbuild = "C:\Program Files (x86)\MSBuild"
    }
    
    $cmd = "Copy-Item -Path `"$contentDir\MSBuild\*`" -Destination `"$msbuild\`" -Recurse -Force"
    if (Test-ProcessAdminRights) {
        Invoke-Expression $cmd
    } else {
        Start-ChocolateyProcessAsAdmin $cmd 
    }

    if (Test-Path "C:\Program Files\Reference Assemblies") {
        $reference = "C:\Program Files\Reference Assemblies"
    }

    if (Test-Path "C:\Program Files (x86)\Reference Assemblies") {
        $reference = "C:\Program Files (x86)\Reference Assemblies"
    }
    
    $cmd = "Copy-Item -Path `"$contentDir\Reference Assemblies\*`" -Destination `"$reference\`" -Recurse -Force"
    if (Test-ProcessAdminRights) {
        Invoke-Expression $cmd
    } else {
        Start-ChocolateyProcessAsAdmin $cmd 
    }

    if (!($env:PATH).Contains("$msbuild\12.0\bin")) {
        $path = "$msbuild\12.0\bin;${env:PATH}"
        $cmd = "[Environment]::SetEnvironmentVariable('PATH','$path', 'Machine')"

        if (Test-ProcessAdminRights) {
            Invoke-Expression $cmd
        } else {
            Start-ChocolateyProcessAsAdmin $cmd
        }
    }
    
    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
