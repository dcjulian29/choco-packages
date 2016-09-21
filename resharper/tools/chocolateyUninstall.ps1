$packageName = "resharper"

$jb = "$env:LOCALAPPDATA\JetBrains\Installations"

& $jb\dotCover06\JetBrains.Platform.Installer.exe /HostsToRemove=dotCover06 /PerMachine=False
& $jb\dotPeek06\JetBrains.Platform.Installer.exe /HostsToRemove=dotPeek06 /PerMachine=False
& $jb\ReSharperPlatformVs14_000\JetBrains.Platform.Installer.exe /HostsToRemove=ReSharperPlatformVs14 /PerMachine=False
