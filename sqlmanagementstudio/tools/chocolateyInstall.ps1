$packageName = "sqlmanagementstudio"
$installerType = "EXE"
$installerArgs = "/QUIETSIMPLE /IACCEPTSQLSERVERLICENSETERMS /ACTION=install /FEATURES=Tools"
$url = "http://download.microsoft.com/download/1/5/6/156992E6-F7C7-4E55-833D-249BD2348138/ENU/x86/SQLManagementStudio_x86_ENU.exe"
$url64 = "http://download.microsoft.com/download/1/5/6/156992E6-F7C7-4E55-833D-249BD2348138/ENU/x64/SQLManagementStudio_x64_ENU.exe"
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
