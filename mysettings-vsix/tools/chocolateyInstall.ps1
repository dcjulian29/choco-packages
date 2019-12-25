$downloadPath = "$env:TEMP\vsix"
$vsix = Find-VSIX
$invalidChars = [IO.Path]::GetInvalidFileNameChars() -join ''
$re = "[{0} ]" -f [RegEx]::Escape($invalidChars)
$date = Get-Date -Format "yyyyMMdd_HHmmss"
$checksum = "52E4DB239FEC80E4FA906E4545309FC93D4A6357"
$packages = @{}

if (Test-Path $downloadPath) {
   Remove-Item -Path $downloadPath -Force -Recurse
}

New-Item -Path $downloadPath -ItemType Directory | Out-Null

Write-Output "Downloading Extensions..."

if (Test-Path "$downloadPath\vsixpackages.zip" ) {
    Remove-Item -Path "$downloadPath\vsixpackages.zip" -Force
}

Download-File -Url "http://dl.julianscorner.com/vsixpackages.zip" `
    -Destination $downloadPath\vsixpackages.zip

if ($(Get-Sha1 $downloadPath\vsixpackages.zip) -ne $checksum) {
    throw "Checksum of downloaded extensions does not match!"
    exit
}

Expand-Archive -Path "$downloadPath\vsixpackages.zip" -DestinationPath $downloadPath `
    | Out-Null

Write-Output "Preparing VSIX Extensions for Install..."

$packageFiles = Get-ChildItem -Path $downloadPath -Filter *.vsix -Recurse

foreach ($package in $packageFiles) {
    $zipFile = "$downloadPath\$($package.BaseName).zip"

    Copy-Item -Path $package.FullName -Destination $zipFile -Force

    $extractDirectory = "$downloadPath\$($package.BaseName)\"

    Expand-Archive -Path $zipFile -DestinationPath $extractDirectory | Out-Null

    $xml = [xml](Get-Content -Path "$extractDirectory\extension.vsixmanifest")

    $extension = $xml.PackageManifest.Metadata.DisplayName

    Write-Output "    --> Adding $extension"

    $packages[$extension] = $package.FullName
}

$script:errorInstalling = $false

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
