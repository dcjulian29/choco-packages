$version = $env:chocolateyPackageVersion
$checksum = 'c13e47d3fb2c849019accb03353c7d04ffb9c264920075972ed2e2befe3cdd8b'
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
$file_path = $env:TEMP + '\' + ($url -split '/' | Select-Object -Last 1)

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
  throw "Can't download latest extension pack"
}

Set-Alias vboxmanage $installLocation\VBoxManage.exe

"y" | vboxmanage extpack install --replace $file_path 2>&1

if ($LastExitCode -ne 0) {
  throw "Extension pack installation failed with exit code $LastExitCode"
}
