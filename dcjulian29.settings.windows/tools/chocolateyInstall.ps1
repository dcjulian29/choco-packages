function installFont($Path) {
  $Path = Get-Item (Resolve-Path $Path)
  $oShell = New-Object -COM Shell.Application
  $folder = $oShell.namespace($Path.DirectoryName)
  $item = $folder.Items().Item($Path.Name)
  $fontName = $folder.GetDetailsOf($item, 21)

  switch ($Path.Extension) {
      ".ttf" { $fontName = "$fontName (TrueType)" }
      ".otf" { $fontName = "$fontName (OpenType)" }
  }

  if (-not (Test-Path "${env:windir}\Fonts\$($Path.Name)")) {
    Copy-Item -Path $Path.FullName -Destination ("${env:windir}\Fonts\$($Path.Name)") `
      -ErrorAction SilentlyContinue

    if ((Test-Path "${env:windir}\Fonts\$($Path.Name)")) {
      Write-Output "Adding '$fontName' to registry....."

      if ($null -ne (Get-ItemProperty -Name $fontName `
          -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" `
          -ErrorAction SilentlyContinue)) {
        if ((Get-ItemPropertyValue -Name $fontName `
            -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts") -eq $Path.Name) {
          Write-Warning "'$fontName' is already installed."
        } else {
          Remove-ItemProperty -Name $fontName `
            -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" -Force
          New-ItemProperty -Name $fontName `
            -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" `
            -PropertyType string -Value $Path.Name `
            -Force -ErrorAction SilentlyContinue | Out-Null
          if ((Get-ItemPropertyValue -Name $fontName `
                -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts") `
              -ne $Path.Name) {
            Write-Error "Adding '$fontname' to registry failed!"
          }
        }
      } else {
        New-ItemProperty -Name $fontName `
          -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" `
          -PropertyType string -Value $Path.Name `
          -Force -ErrorAction SilentlyContinue | Out-Null
        If ((Get-ItemPropertyValue -Name $fontName `
            -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts") -ne $Path.Name) {
          Write-Error "Adding Font to registry failed!"
        }
      }
    } else {
      Write-Error "Unable to copy '$($Path.Name)' to Windows Fonts folder!"
    }
  } else {
    Write-Warning "'$fontName' is already installed."
  }
}

### Console Settings

$cmd = "$env:WINDIR\system32\reg.exe import $PSScriptRoot\console.reg"

if ([System.IntPtr]::Size -ne 4) {
    $cmd = "$cmd /reg:64"
}

Write-Output "Adding console settings to registry..."

cmd /c "$cmd"

### Install My "Nerd" Font

(Get-ChildItem -Path "$PSScriptRoot\fonts").FullName | ForEach-Object {
  installFont $_
}

### Explorer Settings

$cmd = "$env:WINDIR\system32\reg.exe import $PSScriptRoot\explorer.reg"

if ([System.IntPtr]::Size -ne 4) {
  $cmd = "$cmd /reg:64"
}

Write-Output "Adding explorer settings to registry..."

cmd /c "$cmd"

### IPv6 Tunnel settings

$view = [Microsoft.Win32.RegistryView]::Registry32

if (Get-ProcessorBits -eq 64) {
  $view = [Microsoft.Win32.RegistryView]::Registry64
}

$key = [Microsoft.Win32.RegistryKey]::OpenBaseKey([Microsoft.Win32.RegistryHive]::LocalMachine, $view)

Write-Output "Disabling IPv6 tunnels..."

$subKey = $key.OpenSubKey("SYSTEM\CurrentControlSet\services\TCPIP6\Parameters", $true)
$subKey.SetValue("DisabledComponents", 1)

### NTFS Settings

$key = [Microsoft.Win32.RegistryKey]::OpenBaseKey([Microsoft.Win32.RegistryHive]::LocalMachine, $view)

Write-Output "Updating NTFS file system settings..."

$subKey = $key.OpenSubKey("SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management", $true)
$subKey.SetValue("DisablePagingExecutive", 1)

$subKey = $key.OpenSubKey("SYSTEM\CurrentControlSet\Control\FileSystem", $true)
$subKey.SetValue("NtfsDisableLastAccessUpdate", 1)
$subKey.SetValue("NtfsDisableEncryption", 1)
$subKey.SetValue("NtfsDisableCompression", 1)

if ((Get-WmiObject win32_operatingsystem).BuildNumber -lt 10240) {
  $key = [Microsoft.Win32.RegistryKey]::OpenBaseKey([Microsoft.Win32.RegistryHive]::CurrentUser, $view)

  $subKey = $key.OpenSubKey("Software\Microsoft\Windows\CurrentVersion\Policies\Explorer", $true)
  $subKey.SetValue("LinkResolveIgnoreLinkInfo", 1)
  $subKey.SetValue("NoResolveSearch", 1)
  $subKey.SetValue("NoResolveTrack", 1)
  $subKey.SetValue("NoInternetOpenWith", 1)
}

### Power Settings

Write-Output "On AC - monitor off at 30 minutes, standby never, hibernate never..."

powercfg.exe /change monitor-timeout-ac 20
powercfg.exe /change standby-timeout-ac 0
powercfg.exe /change hibernate-timeout-ac 60

Write-Output "On battery - monitor off at 5 minutes, standby at 15, hibernate at 30..."

powercfg.exe /change monitor-timeout-dc 15
powercfg.exe /change standby-timeout-dc 20
powercfg.exe /change hibernate-timeout-dc 30

Write-Output "You need to reboot to complete these changex..."
