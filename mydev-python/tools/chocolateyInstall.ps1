$packageName = "mydev-python"
$downloadPath = "$env:LOCALAPPDATA\Temp\$packageName"

if (Test-Path $downloadPath) {
    Remove-Item $downloadPath -Recurse -Force | Out-Null
}

New-Item -Type Directory -Path $downloadPath | Out-Null

Push-Location $downloadPath

# Install ez_setup
$version = "0.9"
$ezsetup = "https://codeload.github.com/ActiveState/ez_setup/tar.gz/v$version"

Download-File $ezsetup "ez_setup.tar.gz"

& 7z.exe e "ez_setup.tar.gz"
& 7z.exe x "ez_setup-$version.tar"


& python.exe "ez_setup-$version\ez_setup.py"


& pip.exe install pylint
& pip.exe install pep8

& easy_install.exe -U sqlalchemy
& easy_install.exe -U pymongo
& easy_install.exe -U winpdb
