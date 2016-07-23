$packageName = "sqlserverexpress"
$installerType = "EXE"

$url64 = "https://download.microsoft.com/download/E/1/2/E12B3655-D817-49BA-B934-CEB9DAC0BAF3/SQLEXPRADV_x64_ENU.exe"

$downloadPath = "$($env:TEMP)\chocolatey\$packageName"
$dataDir = "$($env:SYSTEMDRIVE)\data"

if ($psISE) {
    Import-Module -name "$($env:ChocolateyInstall)\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try {
    $sid = New-Object Security.Principal.SecurityIdentifier 'S-1-5-32-544'
    $administrators = $sid.Translate([Security.Principal.NTAccount]).Value

    $arg1 = "/QS /ACTION=Install /FEATURES=SQL /TCPENABLED=1 /SKIPRULES=""RebootRequiredCheck"""
    $arg2 = "/INSTANCENAME=MSSQLSERVER /SQLSVCACCOUNT=""NT AUTHORITY\Network Service"""
    $arg3 = "/SQLSYSADMINACCOUNTS=""$($administrators)"" /INSTALLSQLDATADIR=""$($dataDir)"""
    $arg4 = "/AGTSVCACCOUNT=""NT AUTHORITY\Network Service"" /IACCEPTSQLSERVERLICENSETERMS"

    $installerArgs = "$arg1 $arg2 $arg3 $arg4"

    if (-not (Test-Path $dataDir))
    {
        New-Item -Type Directory -Path $dataDir | Out-Null
    }

    if (-not (Test-Path $downloadPath))
    {
        New-Item -Type Directory -Path $downloadPath | Out-Null
    }

    Get-ChocolateyWebFile $packageName "$downloadPath\$packageName.exe" $null $url64
    
    Push-Location $downloadPath
    Invoke-Expression "$downloadPath\$packageName.exe /extract:""$downloadPath"" /Q"
    Pop-Location
    
    Wait-Process -Name $packageName -ErrorAction Silent

    Invoke-Expression "$downloadPath\$packageName\setup.exe $installerArgs"

    Wait-Process -Name "SETUP" -ErrorAction Silent

    Write-ChocolateySuccess $packageName
} catch {
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
