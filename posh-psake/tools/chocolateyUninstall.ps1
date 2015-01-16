$packageName = "posh-psake"
$appDir = "$($env:SYSTEMDRIVE)\Program Files\WindowsPowerShell\Modules\psake"

try
{
    if (Test-Path $appDir)
    {
        $cmd = "Remove-Item `"$($appDir)`" -Recurse -Force"
        if (Test-ProcessAdminRights) {
            Invoke-Expression $cmd
        } else {
            Start-ChocolateyProcessAsAdmin $cmd
        }    
    }

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
