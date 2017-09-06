$packageName = "mysettings-resharper"

$installPath = $(Split-Path -parent $PSscriptRoot)
$installPath = $(Join-Path $installPath 'resharper-platform')
$installPath = $(Get-ChildItem $installPath -Filter "*.exe").FullName

$installArgs = '/SpecificProductNames=ReSharper;dotCover;dotPeek /Silent=True'

Invoke-ElevatedCommand $installPath -ArgumentList $installArgs -Wait
