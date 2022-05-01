# One-time package rename
if (Test-Path "../../iperf-julian") {
  Remove-Item -Path "../../iperf-julian" -Recurse -Force
  return
}
