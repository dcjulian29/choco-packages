$packageName = "smartgit"
$installerType = "EXE"
$installerArgs = "/sp- /silent /norestart"
$url = "http://www.syntevo.com/download/smartgithg/smartgithg-win32-setup-nojre-5_0_5.zip"
$toolDir = "$(Split-Path -parent $MyInvocation.MyCommand.Path)"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
    $ErrorActionPreference = "Stop"
}

try
{
    Get-ChocolateyWebFile $packageName "$toolDir\smartgit.zip" $url
    Get-ChocolateyUnzip "$toolDir\smartgit.zip" "$toolDir\install\"

    $installer = Get-ChildItem "$toolDir\install\" -Recurse -Include *.exe | Select-Object -First 1

    Install-ChocolateyPackage $packageName $installerType $installerArgs $installer

    Remove-Item "$toolDir\install" -Recurse -Force
    Remove-Item "$toolDir\smartgit.zip" -Force

    $java = Join-Path $env:ProgramFiles "Java\jre7"
    
    Start-ChocolateyProcessAsAdmin `
        "[Environment]::SetEnvironmentVariable('SMARTGITHG_JAVA_HOME','$java', 'Machine')"
    
    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
