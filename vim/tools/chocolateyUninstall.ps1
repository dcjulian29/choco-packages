$packageName = "vim"
$appDir = "$($env:SYSTEMDRIVE)\tools\apps\$($packageName)"

try {
    if (Test-Path $appDir)
    {
      Remove-Item "$($appDir)" -Recurse -Force
    }

    if (Test-Path "${env:USERPROFILE}\_vimrc") {
        Remove-Item "${env:USERPROFILE}\_vimrc" -Force
    }

    if (Test-Path "$env:ProgramFiles\Git") {
        $git = "$env:ProgramFiles\Git\bin\git.exe"
    }

    if (Test-Path "${env:ProgramFiles(x86)}\Git") {
        $git = "${env:ProgramFiles(x86)}\Git\bin\git.exe"
    }

    if (Test-Path $git) {
        & $git config --unset --global core.editor
    }

    Remove-Item "$env:ChocolateyInstall\bin\vi.exe" -Force
    Remove-Item "$env:ChocolateyInstall\bin\vim.exe" -Force
    Remove-Item "$env:ChocolateyInstall\bin\gvim.exe" -Force

    Write-ChocolateySuccess $packageName
} catch {
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
