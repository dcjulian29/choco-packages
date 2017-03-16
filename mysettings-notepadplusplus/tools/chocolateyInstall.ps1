$packageName = "mysettings-notepadplusplus"
$toolDir = "$(Split-Path -parent $MyInvocation.MyCommand.Path)"

$appdata = "$($env:APPDATA)\Notepad++"

if (-not (Test-Path $appdata))
{
    New-Item -Type Directory -Path $appdata | Out-Null
}

Copy-Item -Path "$($toolDir)\config.xml" -Destination "$($appdata)\"

if (-not (Test-Path "$($appdata)\themes"))
{
    New-Item -Type Directory -Path "$appdata\themes" | Out-Null
}

Copy-Item -Path "$($toolDir)\MyObsidian.xml" -Destination "$($appdata)\themes\"

$config = [xml](Get-Content "$($appdata)\config.xml")

$settings = $config.NotepadPlus.GUIConfigs
$theme = $settings.GUIConfig | where { $_.name -eq 'stylerTheme' }
$theme.path = "$($appdata)\themes\MyObsidian.xml"

$config.Save("$($appdata)\config.xml")
