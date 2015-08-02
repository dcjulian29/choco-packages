$view = [Microsoft.Win32.RegistryView]::Registry32

if (Get-ProcessorBits -eq 64) {
    $view = [Microsoft.Win32.RegistryView]::Registry64
}

$key = [Microsoft.Win32.RegistryKey]::OpenBaseKey([Microsoft.Win32.RegistryHive]::LocalMachine, $view)

$subKey =  $key.OpenSubKey("SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management", $true)  
$subKey.SetValue("DisablePagingExecutive", 1)

$subKey =  $key.OpenSubKey("SYSTEM\CurrentControlSet\Control\FileSystem", $true)  
$subKey.SetValue("NtfsDisableLastAccessUpdate", 1)
$subKey.SetValue("NtfsDisableEncryption", 1)
$subKey.SetValue("NtfsDisableCompression", 1)

if ((Get-WmiObject win32_operatingsystem).BuildNumber -lt 10240) {
    $key = [Microsoft.Win32.RegistryKey]::OpenBaseKey([Microsoft.Win32.RegistryHive]::CurrentUser, $view)

    $subKey =  $key.OpenSubKey("Software\Microsoft\Windows\CurrentVersion\Policies\Explorer", $true)  
    $subKey.SetValue("LinkResolveIgnoreLinkInfo", 1)
    $subKey.SetValue("NoResolveSearch", 1)
    $subKey.SetValue("NoResolveTrack", 1)
    $subKey.SetValue("NoInternetOpenWith", 1)
}
