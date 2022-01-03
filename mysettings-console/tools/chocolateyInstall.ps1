$cmd = "$env:WINDIR\system32\reg.exe import $PSScriptRoot\registry.reg"

if ([System.IntPtr]::Size -ne 4) {
    $cmd = "$cmd /reg:64"
}

cmd /c "$cmd"

# Install My "Nerd" Font
@("Bold", "ExtraLight", "Light", "Regular", "SemiBold", "SemiLight") | ForEach-Object {
  $font = "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/CascadiaCode/$_/complete/Caskaydia%20Cove%20$_%20Nerd%20Font%20Complete%20Mono%20Windows%20Compatible.otf"

  Invoke-WebRequest -Uri $font `
    -OutFile "${env:TEMP}\Caskaydia Cove $_ Nerd Font Complete Windows Compatible.otf"

  Install-Font -Path "${env:TEMP}\Caskaydia Cove $_ Nerd Font Complete Windows Compatible.otf"

  Remove-Item -Path "${env:TEMP}\Caskaydia Cove $_ Nerd Font Complete Windows Compatible.otf" -Force
}
