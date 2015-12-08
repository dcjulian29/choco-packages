$packageName = "gpg"

if (Test-Path "C:\Program Files\GNU\GnuPG\gpg4win-uninstall.exe")
{
    & 'C:\Program Files\GNU\GnuPG\gpg4win-uninstall.exe' /S
}

if (Test-Path "C:\Program Files (x86)\GNU\GnuPG\gpg4win-uninstall.exe")
{
    & 'C:\Program Files (x86)\GNU\GnuPG\gpg4win-uninstall.exe' /S
}
