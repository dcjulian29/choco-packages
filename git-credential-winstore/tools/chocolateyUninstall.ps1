$packageName = "git-credential-winstore"
$appDir = "$($env:SYSTEMDRIVE)\tools\apps\$($packageName)"

try
{
    if (Test-Path $appDir)
    {
      Remove-Item "$($appDir)" -Recurse -Force
    }

    if (Test-Path "$env:ProgramFiles\Git") {
        $git = "$env:ProgramFiles\Git\bin\git.exe"
    }

    if (Test-Path "${env:ProgramFiles(x86)}\Git") {
        $git = "${env:ProgramFiles(x86)}\Git\bin\git.exe"
    }

    & $git config --unset --global credential.helper
    
    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
