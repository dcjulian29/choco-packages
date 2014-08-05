$packageName = "ravendb-server"
$appDir = "$($env:SYSTEMDRIVE)\tools\apps\$($packageName)"

try
{

    $cmd = "netsh.exe http delete urlacl url=http://+:9020/"
    Start-ChocolateyProcessAsAdmin $cmd

    if (Test-Path $appDir)
    {
      Remove-Item "$($appDir)" -Recurse -Force
    }

    $cmd = "& $appDir\Raven.Server.exe /uninstall"
    Start-ChocolateyProcessAsAdmin $cmd

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
