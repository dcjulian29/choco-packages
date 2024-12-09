$version = $env:chocolateyPackageVersion
$checksum = '9dd60ef3c52c2a318fbbb6faace5862a299b61f678a579988869865dcf7390b6'
$installLocation = Get-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment' `
  VBOX_MSI_INSTALL_PATH -ea 0 | Select-Object -expand VBOX_MSI_INSTALL_PATH

if (!$installLocation) {
  throw "Could not find VirtualBox"
}

if ($installLocation -and $installLocation.EndsWith('\')) {
  $installLocation = $installLocation -replace '.$'
}

if (!(Test-Path $installLocation)) {
  throw "VirtualBox directory does not exist"
}

Write-Output "Installing VirtualBox Extension Pack..."

Write-Warning "*** THIS IS A NON-COMMERCIAL EXTENSION AND CAN INCURE SIGNIFICANT FINANCIAL COSTS ***"

$url = "https://download.virtualbox.org/virtualbox/$version/Oracle_VirtualBox_Extension_Pack-$version.vbox-extpack"
$file_path = $env:TEMP + '\' + ($url_ep -split '/' | Select-Object -Last 1)

Get-ChocolateyWebFile `
  -PackageName    'virtualbox-extensionpack' `
  -FileFullPath   $file_path `
  -Url            $url `
  -Url64bit       $url `
  -Checksum       $checksum `
  -Checksum64     $checksum `
  -ChecksumType   'sha256' `
  -ChecksumType64 'sha256'

if (!(Test-Path $file_path)) {
  throw "Can't download latest extension pack"
}

Set-Alias vboxmanage $installLocation\VBoxManage.exe

"y" | vboxmanage extpack install --replace $file_path 2>&1

if ($LastExitCode -ne 0) {
  throw "Extension pack installation failed with exit code $LastExitCode"
}
