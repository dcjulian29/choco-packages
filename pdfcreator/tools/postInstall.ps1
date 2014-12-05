$key = "{0001B4FD-9EA3-4D90-A79E-FD14BA3AB01D}"

Get-ChildItem HKLM:\SOFTWARE\Classes -Recurse -Include "*$key*" -ErrorAction SilentlyContinue `
    | Remove-Item -Recurse -Force

Remove-Item "$($env:PUBLIC)\Desktop\PDFCreator.lnk" -Force