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
  }
}

$cmd = "$env:WINDIR\system32\reg.exe import $PSScriptRoot\registry.reg"

if ([System.IntPtr]::Size -ne 4) {
    $cmd = "$cmd /reg:64"
}

Write-Output "Adding console settings to registry..."
cmd /c "$cmd"

# Install My "Nerd" Font
@("Bold", "ExtraLight", "Light", "Regular", "SemiBold", "SemiLight") | ForEach-Object {

  $font = 'https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/CascadiaCode/' `
    + "$_" `
    + '/complete/Caskaydia%20Cove%20' + "$_" `
    + '%20Nerd%20Font%20Complete%20Windows%20Compatible.otf'

  $file = "Caskaydia Cove $_ Nerd Font Complete Windows Compatible.otf"

  Invoke-WebRequest -Uri $font -OutFile $file -UseBasicParsing

  if (Test-Path "${env:TEMP}\$file") {
    installFont "${env:TEMP}\$file"
    Remove-Item -Path "${env:TEMP}\$file" -Force
  } else {
    Write-Error "'$file' failed download!"
  }
}
