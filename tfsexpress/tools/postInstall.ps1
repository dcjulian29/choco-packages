Install-WindowsFeature @(
    "Web-WebServer",
    "Web-Mgmt-Tools",
    "Web-Asp-Net45",
    "Web-Scripting-Tools",
    "Web-Scripting-Tools",
    "Web-Dyn-Compression",
    "Web-WebSockets",
    "Web-Windows-Auth")

Get-WebSite | Remove-WebSite

$tfsConfig = "$env:ProgramFiles\Microsoft Team Foundation Server 12.0\Tools\TfsConfig.exe"

$input1 = "WebSitePort=80,SQLInstance=MSSQLSERVER"
$input2 = "CollectionUrl=http://localhost/tfs`;ServiceAccountName=""LOCAL SERVICE""`;ServiceAccountPassword=""pass"""

& "$tfsConfig" unattend /configure /type:Basic /inputs:$input1
& "$tfsConfig" unattend /configure /type:build /inputs:$input2
