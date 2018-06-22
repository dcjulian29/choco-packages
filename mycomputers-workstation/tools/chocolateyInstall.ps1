$url = "http://www.nirsoft.net/utils/searchmyfiles.zip"
$url64 = "http://www.nirsoft.net/utils/searchmyfiles-x64.zip"
$installFile = Join-Path $PSScriptRoot "searchmyfiles.exe"

Install-ChocolateyZipPackage -PackageName "searchmyfiles" -Url $url -url64 $url64 -UnzipLocation $PSScriptRoot

Set-Content -Path "$installFile.gui" -Value $null
