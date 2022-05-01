
$url = "https://raw.githubusercontent.com/dcjulian29/scripts-powershell/main"

Invoke-Expression $(Invoke-WebRequest "$url/install.ps1" -UseBasicParsing)
