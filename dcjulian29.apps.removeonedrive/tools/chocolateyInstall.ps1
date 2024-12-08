Write-Output "Removing OneDrive - Personal..."

if ([System.IntPtr]::Size -ne 4) {
    Start-Process -FilePath "$env:SystemDrive\SysWOW64\OneDriveSetup.exe" -ArgumentList "/uninstall" -Wait
} else {
    Start-Process -FilePath "$env:SystemDrive\System32\OneDriveSetup.exe" -ArgumentList "/uninstall" -Wait
}

New-ItemProperty -Name "@" `
    -Path "HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" `
    -PropertyType string -Value "OneDrive - Personal" -Force

New-ItemProperty -Name "System.IsPinnedToNameSpaceTree" `
    -Path "HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" `
    -PropertyType dword -Value 0 -Force

New-ItemProperty -Name "@" `
    -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" `
    -PropertyType string -Value "OneDrive - Personal" -Force

New-ItemProperty -Name "HiddenByDefault" `
    -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" `
    -PropertyType dword -Value 1 -Force

New-ItemProperty -Name "@" `
    -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\NonEnum" `
    -PropertyType dword -Value 1 -Force
