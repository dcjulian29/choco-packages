$packageName = 'autohotkey'
$appDir = "$($env:SYSTEMDRIVE)\tools\apps\$($packageName)"

if (Test-Path $appDir)
{
  Remove-Item "$($appDir)\*" -Recurse -Force
}

$cmd = "(Get-Item `"`${env:ChocolateyInstall}\bin\ahk.exe`").Delete()"

Invoke-ElevatedExpression $cmd
