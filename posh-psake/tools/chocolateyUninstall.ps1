$packageName = "posh-psake"
$appDir = "$($env:WINDIR)\system32\WindowsPowerShell\v1.0\Modules\psake"

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
