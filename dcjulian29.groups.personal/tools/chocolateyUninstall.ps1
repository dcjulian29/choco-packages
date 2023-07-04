if (Test-Path -Path "${env:TEMP}\dcjulian29.groups.personal.update.txt") {
  Remove-Item -Path "${env:TEMP}\dcjulian29.groups.personal.update.txt" -Force
}
