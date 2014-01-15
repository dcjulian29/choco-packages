$packageName = "gpg"

try
{
    if (Test-Path "C:\Program Files\GNU\GnuPG\gpg4win-uninstall.exe")
    {
        Push-Location "C:\Program Files\GNU\GnuPG\"
    }

    if (Test-Path "C:\Program Files (x86)\GNU\GnuPG\gpg4win-uninstall.exe")
    {
        Push-Location "C:\Program Files (x86)\GNU\GnuPG\"
    }

    cmd /c "gpg4win-uninstall.exe /S"
    
    Pop-Location

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
