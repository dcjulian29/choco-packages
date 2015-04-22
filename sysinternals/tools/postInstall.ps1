$appDir = "$($env:SYSTEMDRIVE)\tools\apps\sysinternals"
$toolDir = "$(Split-Path -parent $MyInvocation.MyCommand.Path)"

$cmd = "reg.exe import '$toolDir\accepteula.reg'"
    
if (Get-ProcessorBits -eq 64) {
    $cmd = "$cmd /reg:64"
}
    
Invoke-Expression $cmd

$mklink = "cmd.exe /c mklink"

$links = @(
"accesschk"
"du"
"hex2dec"
"junction"
"procdump"
"psexec"
"psgetsid"
"pskill"
"pslist"
"psloggedon"
"psloglist"
"pspasswd"
"psping"
"psservice"
"psshutdown"
"pssuspend"
"regjump"
"sdelete"
"tcpvcon"
"whois"
)

foreach ($link in $links) {
    if (Test-Path "${env:ChocolateyInstall}\bin\$link.exe") {
        (Get-Item "${env:ChocolateyInstall}\bin\$link.exe").Delete()
    }

    Invoke-Expression "$mklink ${env:ChocolateyInstall}\bin\$link.exe $appDir\$link.exe"
}
