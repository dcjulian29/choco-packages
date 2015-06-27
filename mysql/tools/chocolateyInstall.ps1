$packageName = "mysql"
$url = "http://cdn.mysql.com/Downloads/MySQL-5.6/mysql-5.6.25-win32.zip"
$url64 = "http://cdn.mysql.com/Downloads/MySQL-5.6/mysql-5.6.25-winx64.zip"
$appDir = "$($env:SYSTEMDRIVE)\tools\apps\$($packageName)"
$downloadPath = "$env:TEMP\chocolatey\$packageName"
$dataDir = "$($env:SYSTEMDRIVE)\data\mysql"
$sn = "MySQL"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try
{
    if (Get-Service | Where-Object { $_.Name -eq $sn }) {
        $cmd = "Stop-Service -ErrorAction 0 -Name $sn;sc.exe delete $sn"
        if (Test-ProcessAdminRights) {
            Invoke-Expression $cmd
        } else {
            Start-ChocolateyProcessAsAdmin $cmd
        }
    }

    if (Test-Path $appDir)
    {
        Write-Output "Removing previous version of package..."
        Remove-Item "$($appDir)" -Recurse -Force
    }

    New-Item -Type Directory -Path $appDir | Out-Null
    
    if (-not (Test-Path $downloadPath))
    {
        New-Item -Type Directory -Path $downloadPath | Out-Null
    }

    Get-ChocolateyWebFile $packageName "$downloadPath\$packageName.zip" $url $url64
    Get-ChocolateyUnzip "$downloadPath\$packageName.zip" "$downloadPath\"

    $extractPath = $(Get-ChildItem -Directory -Path $downloadPath | Select-Object -First 1).Name

    New-Item -Type Directory -Path $appDir\bin | Out-Null
    Copy-Item -Path "$($downloadPath)\$($extractPath)\bin\*" -Destination "$appDir\bin" -Recurse
    New-Item -Type Directory -Path $appDir\bin\share | Out-Null
    Copy-Item -Path "$($downloadPath)\$($extractPath)\share\*" -Destination "$appDir\bin\share" -Recurse

    if (-not (Test-Path $dataDir))
    {
        New-Item -Type Directory -Path $dataDir | Out-Null
        Copy-Item -Path "$($downloadPath)\$($extractPath)\data\*" -Destination "$dataDir" -Recurse
    }

    $config = "$appDir\my.ini"

    Set-Content -Path $config -Encoding Ascii -Value "[mysqld]"
    Add-Content -Path $config -Encoding Ascii -Value "basedir=$(""$appDir\bin"" -replace '\\', '\\')"
    Add-Content -Path $config -Encoding Ascii -Value "datadir=$($dataDir -replace '\\', '\\')"

    $cmd = "& $appDir\bin\mysqld.exe --install"
    if (Test-ProcessAdminRights) {
        Invoke-Expression $cmd
    } else {
        Start-ChocolateyProcessAsAdmin $cmd
    }

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
