$packageName = "nugetexplorer"
$appDir = "$($env:SYSTEMDRIVE)\tools\apps\$($packageName)"

if (Test-Path $appDir)
{
    Remove-Item "$($appDir)" -Recurse -Force
}

$testType = (cmd /c assoc ".nupkg")
if ($testType -ne $null) {
    $fileType = $testType.Split("=")[1]
} else {
    $fileType = "Nuget.Package"
}

Start-ChocolateyProcessAsAdmin "cmd /c ftype $fileType="
