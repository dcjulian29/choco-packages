
$packages = Get-ChildItem  | ?{ $_.PSIsContainer } | Select-Object FullName

$packageList = @()

foreach ($package in $packages) {
    $file = $package.FullName
    $nuspec = [xml](Get-Content "$file\Package.nuspec")

    $detail = New-Object PSObject
    $detail | Add-Member -Type NoteProperty -Name 'Package Name' -Value $nuspec.package.metadata.id
    $detail | Add-Member -Type NoteProperty -Name 'Version' -Value $nuspec.package.metadata.version

    $packageList += $detail
}

$packageList
