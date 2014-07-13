$app = "$($env:SYSTEMDRIVE)\tools\apps\nuget\nuget.exe"
$link = "$($env:ChocolateyInstall)\bin\nuget.exe"


$signature = '
    [DllImport("Kernel32.dll")]
    public static extern bool CreateSymbolicLink(string lpFileName,string lpExistingFileName,IntPtr lpSecurityAttributes);
'

Add-Type -Namespace IO -Name Link -MemberDefinition $signature | Out-Null

if (-not (Test-Path $link)) {
    [IO.Link]::CreateSymbolicLink($link,$app,[IntPtr]::Zero) | Out-Null
}
