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
    (Get-Item "${env:ChocolateyInstall}\bin\$link.exe").Delete()
}
