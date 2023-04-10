Write-Output "Installed Go Version:" 
go version

Write-Output "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`n"

# Go Tool installs:
go install github.com/goreleaser/goreleaser@latest
go install github.com/spf13/cobra-cli@latest
go install golang.org/x/lint/golint@latest
