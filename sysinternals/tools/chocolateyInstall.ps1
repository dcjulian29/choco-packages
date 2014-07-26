$packageName = 'sysinternals'
$downloadPath = "$env:TEMP\chocolatey\$packageName"
$appDir = "$($env:SYSTEMDRIVE)\tools\apps\$($packageName)"
$url = 'http://download.sysinternals.com/files/SysinternalsSuite.zip'

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try
{
    if (Test-Path $appDir)
    {
      Write-Output "Removing previous version of package..."
      Remove-Item "$($appDir)\*" -Recurse -Force
    }

    if (-not (Test-Path $downloadPath)) {
        New-Item -Type Directory -Path $downloadPath | Out-Null
    }

    Get-ChocolateyWebFile $packageName "$downloadPath\$packageName.zip" $url $url
    Get-ChocolateyUnzip "$downloadPath\$packageName.zip" "$downloadPath\"

    if (-not (Test-Path $appDir)) {
        New-Item -Type Directory -Path $appDir | Out-Null
    }

    Get-ChildItem -Path $downloadPath -Exclude "$packageName.zip" | Copy-Item -Destination "$appDir"
    
    Set-Content "$downloadPath\accepteula.reg" @"
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Software\Sysinternals]

[HKEY_CURRENT_USER\Software\Sysinternals\A]
"EulaAccepted"=dword:00000001

[HKEY_CURRENT_USER\Software\Sysinternals\AccessChk]
"EulaAccepted"=dword:00000001

[HKEY_CURRENT_USER\Software\Sysinternals\Active Directory Explorer]
"EulaAccepted"=dword:00000001

[HKEY_CURRENT_USER\Software\Sysinternals\Autologon]
"EulaAccepted"=dword:00000001

[HKEY_CURRENT_USER\Software\Sysinternals\AutoRuns]
"EulaAccepted"=dword:00000001

[HKEY_CURRENT_USER\Software\Sysinternals\BGInfo]
"EulaAccepted"=dword:00000001

[HKEY_CURRENT_USER\Software\Sysinternals\C]
"EulaAccepted"=dword:00000001

[HKEY_CURRENT_USER\Software\Sysinternals\CacheSet]
"EulaAccepted"=dword:00000001

[HKEY_CURRENT_USER\Software\Sysinternals\ClockRes]
"EulaAccepted"=dword:00000001

[HKEY_CURRENT_USER\Software\Sysinternals\Coreinfo]
"EulaAccepted"=dword:00000001

[HKEY_CURRENT_USER\Software\Sysinternals\Ctrl2cap]
"EulaAccepted"=dword:00000001

[HKEY_CURRENT_USER\Software\Sysinternals\DbgView]
"EulaAccepted"=dword:00000001

[HKEY_CURRENT_USER\Software\Sysinternals\Desktops]
"EulaAccepted"=dword:00000001

[HKEY_CURRENT_USER\Software\Sysinternals\Disk2Vhd]
"EulaAccepted"=dword:00000001

[HKEY_CURRENT_USER\Software\Sysinternals\DiskExt]
"EulaAccepted"=dword:00000001

[HKEY_CURRENT_USER\Software\Sysinternals\Diskmon]
"EulaAccepted"=dword:00000001

[HKEY_CURRENT_USER\Software\Sysinternals\DiskView]
"EulaAccepted"=dword:00000001

[HKEY_CURRENT_USER\Software\Sysinternals\EFSDump]
"EulaAccepted"=dword:00000001

[HKEY_CURRENT_USER\Software\Sysinternals\FindLinks]
"EulaAccepted"=dword:00000001

[HKEY_CURRENT_USER\Software\Sysinternals\Handle]
"EulaAccepted"=dword:00000001

[HKEY_CURRENT_USER\Software\Sysinternals\Hex2Dec]
"EulaAccepted"=dword:00000001

[HKEY_CURRENT_USER\Software\Sysinternals\Junction]
"EulaAccepted"=dword:00000001

[HKEY_CURRENT_USER\Software\Sysinternals\LdmDump]
"EulaAccepted"=dword:00000001

[HKEY_CURRENT_USER\Software\Sysinternals\ListDLLs]
"EulaAccepted"=dword:00000001

[HKEY_CURRENT_USER\Software\Sysinternals\LiveKd]
"EulaAccepted"=dword:00000001

[HKEY_CURRENT_USER\Software\Sysinternals\LoadOrder]
"EulaAccepted"=dword:00000001

[HKEY_CURRENT_USER\Software\Sysinternals\LogonSessions]
"EulaAccepted"=dword:00000001

[HKEY_CURRENT_USER\Software\Sysinternals\Movefile]
"EulaAccepted"=dword:00000001

[HKEY_CURRENT_USER\Software\Sysinternals\NewSID]
"EulaAccepted"=dword:00000001

[HKEY_CURRENT_USER\Software\Sysinternals\PageDefrag]
"EulaAccepted"=dword:00000001

[HKEY_CURRENT_USER\Software\Sysinternals\PendMove]
"EulaAccepted"=dword:00000001

[HKEY_CURRENT_USER\Software\Sysinternals\Physmem]
"EulaAccepted"=dword:00000001

[HKEY_CURRENT_USER\Software\Sysinternals\PipeList]
"EulaAccepted"=dword:00000001

[HKEY_CURRENT_USER\Software\Sysinternals\Portmon]
"EulaAccepted"=dword:00000001

[HKEY_CURRENT_USER\Software\Sysinternals\ProcDump]
"EulaAccepted"=dword:00000001

[HKEY_CURRENT_USER\Software\Sysinternals\Process Explorer]
"EulaAccepted"=dword:00000001

[HKEY_CURRENT_USER\Software\Sysinternals\Process Monitor]
"EulaAccepted"=dword:00000001

[HKEY_CURRENT_USER\Software\Sysinternals\ProcFeatures]
"EulaAccepted"=dword:00000001

[HKEY_CURRENT_USER\Software\Sysinternals\PsExec]
"EulaAccepted"=dword:00000001

[HKEY_CURRENT_USER\Software\Sysinternals\psfile]
"EulaAccepted"=dword:00000001

[HKEY_CURRENT_USER\Software\Sysinternals\PsGetSid]
"EulaAccepted"=dword:00000001

[HKEY_CURRENT_USER\Software\Sysinternals\PsInfo]
"EulaAccepted"=dword:00000001

[HKEY_CURRENT_USER\Software\Sysinternals\PsKill]
"EulaAccepted"=dword:00000001

[HKEY_CURRENT_USER\Software\Sysinternals\PsList]
"EulaAccepted"=dword:00000001

[HKEY_CURRENT_USER\Software\Sysinternals\PsLoggedon]
"EulaAccepted"=dword:00000001

[HKEY_CURRENT_USER\Software\Sysinternals\PsLoglist]
"EulaAccepted"=dword:00000001

[HKEY_CURRENT_USER\Software\Sysinternals\PsPasswd]
"EulaAccepted"=dword:00000001

[HKEY_CURRENT_USER\Software\Sysinternals\PsPing]
"EulaAccepted"=dword:00000001

[HKEY_CURRENT_USER\Software\Sysinternals\PsService]
"EulaAccepted"=dword:00000001

[HKEY_CURRENT_USER\Software\Sysinternals\PsShutdown]
"EulaAccepted"=dword:00000001

[HKEY_CURRENT_USER\Software\Sysinternals\PsSuspend]
"EulaAccepted"=dword:00000001

[HKEY_CURRENT_USER\Software\Sysinternals\RamMap]
"EulaAccepted"=dword:00000001

[HKEY_CURRENT_USER\Software\Sysinternals\RegDelNull]
"EulaAccepted"=dword:00000001

[HKEY_CURRENT_USER\Software\Sysinternals\Reghide]
"EulaAccepted"=dword:00000001

[HKEY_CURRENT_USER\Software\Sysinternals\Regjump]
"EulaAccepted"=dword:00000001

[HKEY_CURRENT_USER\Software\Sysinternals\RootkitRevealer]
"EulaAccepted"=dword:00000001

[HKEY_CURRENT_USER\Software\Sysinternals\SDelete]
"EulaAccepted"=dword:00000001

[HKEY_CURRENT_USER\Software\Sysinternals\Share Enum]
"EulaAccepted"=dword:00000001

[HKEY_CURRENT_USER\Software\Sysinternals\ShareEnum]
"EulaAccepted"=dword:00000001

[HKEY_CURRENT_USER\Software\Sysinternals\ShellRunas - Sysinternals: www.sysinternals.com]
"EulaAccepted"=dword:00000001

[HKEY_CURRENT_USER\Software\Sysinternals\SigCheck]
"EulaAccepted"=dword:00000001

[HKEY_CURRENT_USER\Software\Sysinternals\Streams]
"EulaAccepted"=dword:00000001

[HKEY_CURRENT_USER\Software\Sysinternals\Strings]
"EulaAccepted"=dword:00000001

[HKEY_CURRENT_USER\Software\Sysinternals\Sync]
"EulaAccepted"=dword:00000001

[HKEY_CURRENT_USER\Software\Sysinternals\TCPView]
"EulaAccepted"=dword:00000001

[HKEY_CURRENT_USER\Software\Sysinternals\VMMap]
"EulaAccepted"=dword:00000001

[HKEY_CURRENT_USER\Software\Sysinternals\VolumeID]
"EulaAccepted"=dword:00000001

[HKEY_CURRENT_USER\Software\Sysinternals\Whois]
"EulaAccepted"=dword:00000001

[HKEY_CURRENT_USER\Software\Sysinternals\Winobj]
"EulaAccepted"=dword:00000001

[HKEY_CURRENT_USER\Software\Sysinternals\ZoomIt]
"EulaAccepted"=dword:00000001

[HKEY_USERS\.DEFAULT\Software\Sysinternals\PsExec]
"EulaAccepted"=dword:00000001

[HKEY_USERS\.DEFAULT\Software\Sysinternals\PsInfo]
"EulaAccepted"=dword:00000001

[HKEY_USERS\.DEFAULT\Software\Sysinternals\PsKill]
"EulaAccepted"=dword:00000001

[HKEY_USERS\.DEFAULT\Software\Sysinternals\PsList]
"EulaAccepted"=dword:00000001
"@

   $cmd = "reg.exe import '$downloadPath\accepteula.reg'"
    
    if (Get-ProcessorBits -eq 64) {
        $cmd = "$cmd /reg:64"
    }
    
    Start-ChocolateyProcessAsAdmin $cmd

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
