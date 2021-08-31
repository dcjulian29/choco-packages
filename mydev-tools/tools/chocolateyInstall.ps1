$npmPath = "$($env:ProgramFiles)\nodejs\npm.cmd"
$modulesPath = "$($env:APPDATA)\npm\node_modules"
$modules = @(
    "bower"
    "gulp"
    "grunt-cli"
    "yo"
    "generator-aspnet"
    "generator-express"
    "generator-hottowel"
    "generator-meanjs"
    "generator-sails-rest-api"
    "generator-hubot"
    "csslint"
    "jslint"
    "jshint"
    "typescript"
    "pm2"
)


$modules | ForEach-Object {
    if (-not (Get-ChildItem $modulesPath -Filter $_)) {
        & $npmPath install -g $_
    }
}

Start-Process -FilePath "python.exe" -ArgumentList "-m pip install --upgrade pip" -NoNewWindow -Wait

$python = @(
    "pylint"
    "pep8"
    "httpie"
    "pymongo"
    "pymysql"
    "psycopg2"
    "tinydb"
    "redis"
    "sqlalchemy"
    "winpdb"
    "paramiko"
    "pendulum"
    "six"
    "pyyaml"
    "pillow"
    "pyopenssl"
    "bcrypt"
    "elasticsearch"
    "slackclient"
    "selenium"
    "websockets"
    "geopy"
    "graphviz"
    "semver"
    "requests"
    "urllib3"
    "docker"
    "kubernetes"
)

$python | ForEach-Object {
    & pip.exe install $_
}
