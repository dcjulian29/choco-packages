$view = [Microsoft.Win32.RegistryView]::Registry32

if (Get-ProcessorBits -eq 64) {
    $view = [Microsoft.Win32.RegistryView]::Registry64
}

$key = [Microsoft.Win32.RegistryKey]::OpenBaseKey([Microsoft.Win32.RegistryHive]::LocalMachine, $view)

$subKey =  $key.OpenSubKey("SYSTEM\CurrentControlSet\services\TCPIP6\Parameters", $true)  
$subKey.SetValue("DisabledComponents", 1)
