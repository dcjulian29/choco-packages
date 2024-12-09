$version = $env:chocolateyPackageVersion
$url = "https://github.com/ryanoasis/nerd-fonts/releases/download/v$version/CascadiaCode.zip"
$checksum = "045c12b3302989c291f92d0ba3bfcb6d37f633711fb8f22d822acb923bff0c94"
$file_path = $env:TEMP + '\CaskaydiaCove.zip'
$extract_path = $env:TEMP + '\CaskaydiaCove\'

Get-ChocolateyWebFile `
  -PackageName    $env:chocolateyPackageName `
  -FileFullPath   $file_path `
  -Url            $url `
  -Url64bit       $url `
  -Checksum       $checksum `
  -Checksum64     $checksum `
  -ChecksumType   'sha256' `
  -ChecksumType64 'sha256'

if (!(Test-Path $file_path)) {
  throw "Can't download CaskaydiaCove Nerd Font"
}

Unzip-File -File $file_path -Destination $extract_path

(Get-ChildItem -Path $extract_path -Filter "*.ttf").FullName | ForEach-Object {
  $font_path = Get-Item (Resolve-Path $_)
  $shell = New-Object -COM Shell.Application
  $folder = $shell.namespace($font_path.DirectoryName)
  $item = $folder.Items().Item($font_path.Name)
  $font_name = $folder.GetDetailsOf($item, 21) + " (TrueType)"

  Copy-Item -Path $font_path.FullName -Destination ("${env:windir}\Fonts\$($font_path.Name)") `
    -Force -ErrorAction SilentlyContinue

  if ((Test-Path "${env:windir}\Fonts\$($font_path.Name)")) {
    Write-Output "Adding '$font_name' to registry....."

    if ($null -ne (Get-ItemProperty -Name $font_name `
          -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" `
          -ErrorAction SilentlyContinue)) {
      Remove-ItemProperty -Name $font_name `
        -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" -Force
    }

    New-ItemProperty -Name $font_name `
      -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" `
      -PropertyType string -Value $font_path.Name `
      -Force -ErrorAction SilentlyContinue | Out-Null

    if ((Get-ItemPropertyValue -Name $font_name `
          -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts") -ne $font_path.Name) {
      Write-Error "Adding Font to registry failed!"
    }
  }
  else {
    Write-Error "Unable to copy '$($font_path.Name)' to Windows Fonts folder!"
  }
}
