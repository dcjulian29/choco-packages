$packageName = "msbuild"
$installerType = "EXE"
$installerArgs = "/passive /norestart"
$url = "http://download.microsoft.com/download/9/B/B/9BB1309E-1A8F-4A47-A6C5-ECF76672A3B3/BuildTools_Full.exe"
$content = "https://julianscorner.com/downloads/msbuild-2013.zip"
$downloadPath = "$($env:TEMP)\chocolatey\$($packageName)"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

Install-ChocolateyPackage $packageName $installerType $installerArgs $url $url

if (Test-Path "C:\Program Files\MSBuild") {
    $msbuild = "C:\Program Files\MSBuild"
}

if (Test-Path "C:\Program Files (x86)\MSBuild") {
    $msbuild = "C:\Program Files (x86)\MSBuild"
}

if (-not (Test-Path $downloadPath)) {
    New-Item -Type Directory -Path $downloadPath | Out-Null
}

Get-ChocolateyWebFile $packageName "$downloadPath\$packageName.zip" $content
Get-ChocolateyUnzip "$downloadPath\$packageName.zip" "$downloadPath\"
    
$cmd = "Copy-Item -Path `"$downloadPath\MSBuild\*`" -Destination `"$msbuild\`" -Recurse -Force"
if (Test-ProcessAdminRights) {
    Invoke-Expression $cmd
} else {
    Start-ChocolateyProcessAsAdmin $cmd 
}

if (Test-Path "C:\Program Files\Reference Assemblies") {
    $reference = "C:\Program Files\Reference Assemblies"
}

if (Test-Path "C:\Program Files (x86)\Reference Assemblies") {
    $reference = "C:\Program Files (x86)\Reference Assemblies"
}
    
$cmd = "Copy-Item -Path `"$downloadPath\Reference Assemblies\*`" -Destination `"$reference\`" -Recurse -Force"
if (Test-ProcessAdminRights) {
    Invoke-Expression $cmd
} else {
    Start-ChocolateyProcessAsAdmin $cmd 
}

if (!($env:PATH).Contains("$msbuild\12.0\bin")) {
    $path = "$msbuild\12.0\bin;${env:PATH}"
    $cmd = "[Environment]::SetEnvironmentVariable('PATH','$path', 'Machine')"

    if (Test-ProcessAdminRights) {
        Invoke-Expression $cmd
    } else {
        Start-ChocolateyProcessAsAdmin $cmd
    }
}

$cmd = "[Environment]::SetEnvironmentVariable('VisualStudioVersion','12.0', 'Machine')"

if (Test-ProcessAdminRights) {
    Invoke-Expression $cmd
} else {
    Start-ChocolateyProcessAsAdmin $cmd
}
