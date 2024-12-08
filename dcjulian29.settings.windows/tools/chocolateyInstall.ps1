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

### Registry Settings

if ([System.IntPtr]::Size -ne 4) {
    $cmd = "$cmd /reg:64"
}

(Get-childItem -Path "$PSscriptRoot"  -Filter "*.reg").FullName | ForEach-Object {
  Write-Output "Adding to registry: $($_)"
  cmd /c "$cmd $($_)"
}

## Fonts

(Get-ChildItem -Path "$PSScriptRoot\fonts").FullName | ForEach-Object {
  installFont $_
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

Write-Output "You need to reboot to complete these changes..."
