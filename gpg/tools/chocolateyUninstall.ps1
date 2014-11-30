$packageName = "gpg"

try
{
    if (Test-Path "C:\Program Files\GNU\GnuPG\gpg4win-uninstall.exe")
    {
        cmd /c "C:\Program Files\GNU\GnuPG\gpg4win-uninstall.exe /S"
    }

    if (Test-Path "C:\Program Files (x86)\GNU\GnuPG\gpg4win-uninstall.exe")
    {
        cmd /c "C:\Program Files (x86)\GNU\GnuPG\gpg4win-uninstall.exe /S"
    }

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
