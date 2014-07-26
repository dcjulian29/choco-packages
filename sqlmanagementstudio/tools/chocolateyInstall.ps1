$packageName = "sqlmanagementstudio"
$installerType = "EXE"
$installerArgs = "/QUIETSIMPLE /IACCEPTSQLSERVERLICENSETERMS /ACTION=install /FEATURES=Tools"
$url = "http://download.microsoft.com/download/E/A/E/EAE6F7FC-767A-4038-A954-49B8B05D04EB/MgmtStudio%2032BIT/SQLManagementStudio_x86_ENU.exe"
$url64 = "http://download.microsoft.com/download/E/A/E/EAE6F7FC-767A-4038-A954-49B8B05D04EB/MgmtStudio%2064BIT/SQLManagementStudio_x64_ENU.exe"
$downloadPath = "$($env:TEMP)\chocolatey\$packageName"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try
{
    if (-not (Test-Path $downloadPath))
    {
        New-Item -Type Directory -Path $downloadPath | Out-Null
    }

    Get-ChocolateyWebFile $packageName "$downloadPath\$packageName.exe" $url $url64
    
    Push-Location $downloadPath
    Invoke-Expression "$downloadPath\$packageName.exe /extract:""$downloadPath"" /Q"
    Pop-Location
    
    Wait-Process -Name $packageName -ErrorAction Silent

    Invoke-Expression "$downloadPath\$packageName\setup.exe $installerArgs"

    Wait-Process -Name "SETUP" -ErrorAction Silent

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
