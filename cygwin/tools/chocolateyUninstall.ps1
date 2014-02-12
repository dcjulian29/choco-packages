$packageName = "cygwin"
$appDir = "$($env:SystemDrive)\$($packageName)"
$toolDir = "$(Split-Path -parent $MyInvocation.MyCommand.Path)"

try
{
    if (Test-Path $appDir)
    {
        $remove = "Remove-Item '$($appDir)' -Recurse -Force"
        Start-ChocolateyProcessAsAdmin $remove
    
        $cmd = "reg.exe import $toolDir\registry.reg"
        
        Start-ChocolateyProcessAsAdmin "$cmd"

        if (Get-ProcessorBits -eq 64) {
            $cmd = "$cmd /reg:64"
            Start-ChocolateyProcessAsAdmin "$cmd"
        }
    }

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
