$definition = @"
using System;
using System.Runtime.InteropServices; 
 
namespace Win32
{
    public class Api
    {
        [DllImport("ntdll.dll", EntryPoint="RtlAdjustPrivilege")]
        public static extern int RtlAdjustPrivilege(ulong Privilege, bool Enable, bool CurrentThread, ref bool Enabled);
    }
}
"@ 
 
Add-Type -TypeDefinition $definition -PassThru  | Out-Null

New-PSDrive -PSProvider registry -Root HKEY_CLASSES_ROOT  -Name HKCR | Out-Null

$enabled = $false
$rule = New-Object System.Security.AccessControl.RegistryAccessRule ($env:USERNAME,"FullControl","Allow")
$res = [Win32.Api]::RtlAdjustPrivilege(9, $true, $false, [ref]$enabled)

# OneDrive
try {
    $key = [Microsoft.Win32.Registry]::ClassesRoot.OpenSubKey( `
        "CLSID\{8E74D236-7F35-4720-B138-1FED0B85EA75}\ShellFolder", `
        [Microsoft.Win32.RegistryKeyPermissionCheck]::ReadWriteSubTree, `
        [System.Security.AccessControl.RegistryRights]::takeownership)
} catch {
    Write-Warning "Unable to retrieve OneDrive registry key..."
}

if ($key) {
    $acl = $key.GetAccessControl()
    $acl.SetOwner([System.Security.Principal.NTAccount]$env:USERNAME)
    $key.SetAccessControl($acl)

    $acl = $key.GetAccessControl()
    $acl.SetAccessRule($rule)
    $key.SetAccessControl($acl)

    $key.close()

    $Path = "HKCR:\CLSID\{8E74D236-7F35-4720-B138-1FED0B85EA75}\ShellFolder"

    if ((Get-ItemProperty -path $Path -Name Attributes).Attributes -eq 4034920525) {
        Set-ItemProperty -Path $path -Name Attributes -value 2668101709 
    }
}

# HomeGroup
try {
    $key = [Microsoft.Win32.Registry]::ClassesRoot.OpenSubKey( `
        "CLSID\{B4FB3F98-C1EA-428D-A78A-D1F5659CBA93}\ShellFolder", `
        [Microsoft.Win32.RegistryKeyPermissionCheck]::ReadWriteSubTree, `
        [System.Security.AccessControl.RegistryRights]::takeownership)
} catch {
    Write-Warning "Unable to retrieve HomeGroup registry key..."
}

if ($key) {
    $acl = $key.GetAccessControl()
    $acl.SetOwner([System.Security.Principal.NTAccount]$env:USERNAME)
    $key.SetAccessControl($acl)

    $acl = $key.GetAccessControl()
    $acl.SetAccessRule($rule)
    $key.SetAccessControl($acl)

    $key.close()

    $Path = "HKCR:\CLSID\{B4FB3F98-C1EA-428D-A78A-D1F5659CBA93}\ShellFolder"

    if ((Get-ItemProperty -path $Path -Name Attributes).Attributes -eq 2961441036) {
        Set-ItemProperty -Path $path -Name Attributes -value 2962489612 
    }
}

& sc.exe config HomeGroupProvider start= disabled
& sc.exe config HomeGroupListener start= disabled
