$packageName = "ravendb-server"
$build = "3528"
$url = "http://hibernatingrhinos.com/downloads/RavenDB/$build"

$appDir = "$($env:SYSTEMDRIVE)\tools\apps\$($packageName)"
$downloadPath = "$env:TEMP\chocolatey\$packageName"
$dataDir = "$($env:SYSTEMDRIVE)\data\raven"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try
{
    if (Test-Path $appDir)
    {
        Write-Output "Removing previous version of package..."
        Remove-Item "$($appDir)" -Recurse -Force
    }

    New-Item -Type Directory -Path $appDir | Out-Null
    
    if (-not (Test-Path $downloadPath))
    {
        New-Item -Type Directory -Path $downloadPath | Out-Null
    }

    Get-ChocolateyWebFile $packageName "$downloadPath\$packageName.zip" $url
    Get-ChocolateyUnzip "$downloadPath\$packageName.zip" "$downloadPath\"

    Copy-Item -Path "$($downloadPath)\Server\*" -Destination "$appDir" -Recurse -Container

    if (-not (Test-Path $dataDir))
    {
        New-Item -Type Directory -Path $dataDir | Out-Null
    }
    
    $config = [xml](Get-Content "$($appDir)\Raven.Server.exe.config")
    $settings = $config.configuration.'appsettings'

    $port = $settings.add | where { $_.Key -eq 'Raven/Port' }
    $port.value = "9020"

    $dbDirectory = $settings.add | where { $_.Key -eq 'Raven/DataDir' }
    $dbDirectory.value = "$($dataDir)\System"

    $compiledIndexCacheDirectory = $config.CreateElement("add")
    $compiledIndexCacheDirectory.SetAttribute("key", "Raven/CompiledIndexCacheDirectory")
    $compiledIndexCacheDirectory.SetAttribute("value", "$($dataDir)\CompiledIndexCache")
    $settings.AppendChild($compiledIndexCacheDirectory) | Out-Null

    $config.Save("$($appDir)\Raven.Server.exe.config")
    
    $cmd = "netsh.exe http add urlacl url=http://+:9020/ user=""Everyone"""
    Start-ChocolateyProcessAsAdmin $cmd

    $cmd = "& $appDir\Raven.Server.exe /install"
    Start-ChocolateyProcessAsAdmin $cmd

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
