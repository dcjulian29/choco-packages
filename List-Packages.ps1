
$packages = Get-ChildItem  | ?{ $_.PSIsContainer } | Select-Object FullName

foreach ($package in $packages) {
    $file = $package.FullName
    $nuspec = [xml](Get-Content "$file\Package.nuspec")

    $packageName = $nuspec.package.metadata.id
    $version = $nuspec.package.metadata.version
    $website = $nuspec.package.metadata.projectUrl

    Write-Output "$packageName [$version]  $website"

}
