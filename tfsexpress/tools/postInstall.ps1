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

$tfsConfig = "$env:ProgramFiles\Microsoft Team Foundation Server 14.0\Tools\TfsConfig.exe"

$input1 = "WebSitePort=80;SQLInstance=127.0.0.1"
$input2 = "CollectionUrl=http://localhost/tfs;IsServiceAccountBuiltIn=True;ServiceAccountName=NT AUTHORITY\LOCAL SERVICE"

& "$tfsConfig" unattend /configure /type:Basic /inputs:$input1
& "$tfsConfig" unattend /configure /type:build /inputs:$input2
