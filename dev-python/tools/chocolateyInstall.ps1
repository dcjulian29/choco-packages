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
