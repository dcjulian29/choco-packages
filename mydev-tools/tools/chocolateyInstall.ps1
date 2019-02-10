$npmPath = "$($env:ProgramFiles)\nodejs\npm.cmd"
$modulesPath = "$($env:APPDATA)\npm\node_modules"
$modules = @(
    "bower"
    "gulp grunt-cli"
    "yo"
    "generator-aspnet generator-express"
    "generator-hottowel generator-meanjs generator-sails-rest-api"
    "generator-hubot"
    "csslint"
    "jslint jshint"
    "typescript"
    "pm2"
)

$modules | ForEach-Object {
    if (-not (Get-ChildItem $modulesPath -Filter $_)) {
        & $npmPath install -g $_
    }
}


$python = @(
    "pylint"
    "pep8"
    "httpie"
    "pymongo"
    "pymysql"
    "pyodbc"
    "psycopg2"
    "tinydb"
    "redis"
    "sqlalchemy"
    "winpdb"
)

$python | ForEach-Object {
    & pip.exe install $_
}