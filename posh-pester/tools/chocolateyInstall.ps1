$packageName = "posh-pester"
$version = "3.4.6"
$url = "https://codeload.github.com/pester/Pester/zip/$version"
$appDir = "$($env:UserProfile)\Documents\WindowsPowerShell\Modules\pester"
$downloadPath = "$env:TEMP\$packageName"

if (Test-Path $downloadPath)
{
    Remove-Item -Path $downloadPath -Recurse -Force
}

New-Item -Type Directory -Path $downloadPath | Out-Null

(New-Object System.Net.WebClient).DownloadFile($url, "$downloadPath\$version.zip")

[System.Reflection.Assembly]::LoadWithPartialName("System.IO.Compression.FileSystem") | Out-Null
[System.IO.Compression.ZipFile]::ExtractToDirectory("$downloadPath\$version.zip", $downloadPath)

if (Test-Path $appDir)
{
  Write-Output "Removing previous version of package..."
  Remove-Item "$($appDir)" -Recurse -Force
}

$source = "$downloadPath\Pester-$version"
New-Item -Type Directory -Path $appDir | Out-Null

Copy-Item -Path "$source\Pester.ps*" -Destination "$appDir"
New-Item -Type Directory -Path "$appDir\en-US" | Out-Null
Copy-Item -Path "$source\en-US\*" -Destination "$appDir\en-US"
New-Item -Type Directory -Path "$appDir\Functions" | Out-Null
Copy-Item -Path "$source\Functions\*" -Destination "$appDir\Functions" -Recurse
