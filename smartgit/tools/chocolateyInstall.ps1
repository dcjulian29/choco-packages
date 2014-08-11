$packageName = "smartgit"
$installerType = "EXE"
$installerArgs = "/sp- /silent /norestart"
$url = "http://www.syntevo.com/download/smartgithg/smartgithg-win32-setup-nojre-6_0_1.zip"
$downloadPath = "$env:TEMP\chocolatey\$packageName"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try
{
    if (-not (Test-Path $downloadPath))
    {
        New-Item -Type Directory -Path $downloadPath | Out-Null
    }

    Get-ChocolateyWebFile $packageName "$downloadPath\$packageName.zip" $url
    Get-ChocolateyUnzip "$downloadPath\$packageName.zip" "$downloadPath\"

    $installer = Get-ChildItem "$downloadPath" -Recurse -Include *.exe | Select-Object -First 1

    Install-ChocolateyPackage $packageName $installerType $installerArgs $installer

    if (Test-Path "C:\Program Files (x86)\Java\jre7") {
        $java = "C:\Program Files (x86)\Java\jre7"
    
        Start-ChocolateyProcessAsAdmin `
            "[Environment]::SetEnvironmentVariable('SMARTGITHG_JAVA_HOME','$java', 'Machine')"
    }
    
    Start-ChocolateyProcessAsAdmin "Remove-Item '$($env:PUBLIC)\Desktop\SmartGitHg 6.lnk' -Force"
    
    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
