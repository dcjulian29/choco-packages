$images = @(
    "alpine"
    "docker.elastic.co/elasticsearch/elasticsearch:7.10.0"
    "docker.elastic.co/kibana/kibana:7.10.0"
    "graylog/graylog:4.0"
    "mailhog/mailhog:latest"
    "mongo:4.2"
    "mongo:latest"
    "mcr.microsoft.com/mssql/server:2019-latest"
    "mysql:latest"
    "postgres:latest"
    "redis:latest"
)

$images | ForEach-Object {
    Pull-DockerImage -Name $_.Split(':')[0] -Tag $_.Split(':')[1]
}
