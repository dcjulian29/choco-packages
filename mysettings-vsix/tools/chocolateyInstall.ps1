$vsixPath = "$env:SystemDrive\etc\visualstudio\vsix"
$vsix = Find-VSIX
$invalidChars = [IO.Path]::GetInvalidFileNameChars() -join ''
$re = "[{0} ]" -f [RegEx]::Escape($invalidChars)
$date = Get-Date -Format "yyyyMMdd_HHmmss"
$packages = @{}

Write-Output "Preparing VSIX Extensions for Install..."

$packageFiles = Get-ChildItem -Path $vsixPath -Filter *.vsix -Recurse

foreach ($package in $packageFiles) {
    $zipFile = "$env:TEMP\$($package.BaseName).zip"

    Copy-Item -Path $package.FullName -Destination $zipFile -Force

    $extractDirectory = "$env:TEMP\$($package.BaseName)\"

    Expand-Archive -Path $zipFile -DestinationPath $extractDirectory | Out-Null

    $xml = [xml](Get-Content -Path "$extractDirectory\extension.vsixmanifest")

    $extension = $xml.PackageManifest.Metadata.DisplayName

    Write-Output "    --> Adding $extension"

    $packages[$extension] = $package.FullName
}

$script:errorInstalling = $false

Write-Output "Installing VSIX Extensions..."

foreach ($package in $packages.Keys) {
    $originalErrorAction = $ErrorActionPreference

    $ErrorActionPreference = 'Stop'

    $logFile = "{1}-vsix-{0}.log" -f ($package -replace $re), $date
    $vsixFile = $packages[$package]

    Write-Output " "
    Write-Output "=========================================================="
    Write-Output "Installing $package Extension"
    Write-Output "    VSIX File: $vsixFile"
    Write-Output "    Log File: $(Get-LogFolder)\$logFile"
    Write-Output " "

    try {
        $arguments = @(
            "/quiet"
            "/logFile:$logFile"
            "$vsixFile"
        )

        $run = Start-Process -FilePath $vsix -ArgumentList $arguments -PassThru -Wait -NoNewWindow -Verbose

        Move-Item -Path $env:TEMP\$logFile -Destination "$(Get-LogFolder)\$logFile"

        $exitCode = [Int32]$run.ExitCode

        if ($exitCode -eq 1001) {
            Write-Output "INFORMATION: The $package Extension is already installed."
        } else {
            if ($exitCode -gt 0) { throw }
        }
    } catch {
        $errorMessage = $_.Exception.Message
        Write-Output " "
        Write-Output "An error occurred during installation of the $package Extension..."
        Write-Output "Error: $errorMessage"
        Write-Output "Review the log file: $(Get-LogFolder)\$logFile"
        $script:errorInstalling = $true
    }

     $ErrorActionPreference = $originalErrorAction
 }

if ($script:errorInstalling) {
    throw "An Error occurred installing one of the VSIX extentions. Review the log file..."
}
