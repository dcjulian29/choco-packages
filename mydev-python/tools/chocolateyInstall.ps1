$packageName = "mydev-python"
$downloadPath = "$env:LOCALAPPDATA\Temp\$packageName"

if (Test-Path $downloadPath) {
    Remove-Item $downloadPath -Recurse -Force | Out-Null
}

New-Item -Type Directory -Path $downloadPath | Out-Null

Push-Location $downloadPath

# Install ez_setup
$version = "0.9"
$ezsetup = "https://pypi.python.org/packages/source/e/ez_setup/ez_setup-$version.tar.gz"

Download-File $ezsetup "ez_setup.tar.gz"

& 'C:\Program Files\7-Zip\7z.exe' e "ez_setup.tar.gz"
& 'C:\Program Files\7-Zip\7z.exe' x "ez_setup-$version.tar"


& python.exe "ez_setup-$version\ez_setup.py"

# Install pip
Download-File "https://bootstrap.pypa.io/get-pip.py" "get-pip.py"

Pop-Location

& python.exe get-pip.py

& pip.exe install pylint
& pip.exe install pep8

& easy_install.exe -U sqlalchemy
& easy_install.exe -U pymongo
& easy_install.exe -U winpdb
