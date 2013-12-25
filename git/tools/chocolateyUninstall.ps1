$packageName = 'git'

try
{
    $uninstaller = Join-Path $env:ProgramFiles "Git\unins000.exe"
    
    if ((Get-WmiObject Win32_Processor).AddressWidth -eq 64) { 
        $uninstaller = Join-Path $env:ProgramW6432 "Git\unins000.exe"
    }

    if (Test-Path $uninstaller)
    {
        Start-ChocolateyProcessAsAdmin "cmd.exe /c `"$uninstaller`" /SILENT"
    }

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
