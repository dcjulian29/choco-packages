function installPackage($Package) {
  setSettings "InstallPackage" $Package

  $logFile = Get-LogFileName -Suffix "$env:COMPUTERNAME-$package"

  Start-Transcript $logFile

  Invoke-Expression "choco.exe install $Package -y"

  Stop-Transcript

  setSettings $Package $(Get-Date)

  if (Get-Content $logFile | Select-String -Pattern "^Failures|ERROR:") {
    Write-Warning "An error occurred during the last package ($Package) install..."
    Write-Warning "Review the output and then decide whether to continue..."
    Start-Sleep -Seconds 30
  }

  if (Test-PendingReboot) {
    Write-Warning "One of the packages recently installed has set the PendingReboot flag..."
    Write-Warning "Restarting Computer in 30 seconds..."
    Start-Sleep -Seconds 30
    Restart-Computer -Force
  }
}

funtion getSettingsFile {
  if (Test-Path "${env:TEMP}\julian-bootstrap.json") {
    ConvertTo-Json @{} | Out-File "${env:TEMP}\julian-bootstrap.json"
  }

  Get-Content -Path "${env:TEMP}\julian-bootstrap.json"
}

function getSetting($Key) {
  $settings = getSettingsFile | ConvertFrom-Json

  return $settings.$Key
}

function setSettings($Key, $Value) {
  $settings = getSettingsFile | ConvertFrom-Json

  if ($settings.$Key) {
    $settings.PSObject.Properties.Remove($Key)
  }

  $settings | Add-Member -MemberType NoteProperty -Name $Key -Value $Value
}

#------------------------------------------------------------------------------

if (-not ($(getSetting "FinishBootstrap") -eq "Yes" )) {
  Write-Warning "This bootstrap script has completed and should be removed from auto run."
  Start-Sleep -Seconds 30
  exit
}

if (-not ($(getSetting "BootstrapStarted") -eq "Yes" )) {
  setSettings "BootstrapStarted" "Yes"

  Restore-ChocolateyCache
}

#------------------------------------------------------------------------------

@(
  "mytools-scm"
  "mytolls-personal"
  "mytools-database"
  "mydevices-devvm"
) | ForEach-Object {
  if (-not ($(getSetting $_))) {
    installPackage $_
  }
}

#------------------------------------------------------------------------------

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Select Development Packages'
$form.Size = New-Object System.Drawing.Size(300, 200)

$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Point(75,120)
$OKButton.Size = New-Object System.Drawing.Size(75,23)
$OKButton.Text = 'OK'
$OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $OKButton
$form.Controls.Add($OKButton)

$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Point(150,120)
$CancelButton.Size = New-Object System.Drawing.Size(75,23)
$CancelButton.Text = 'Cancel'
$CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $CancelButton
$form.Controls.Add($CancelButton)

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(280,20)
$label.Text = 'Please select development packages to install:'
$form.Controls.Add($label)

$listBox = New-Object System.Windows.Forms.Listbox
$listBox.Location = New-Object System.Drawing.Point(10,40)
$listBox.Size = New-Object System.Drawing.Size(260,20)

$listBox.SelectionMode = 'MultiExtended'

[void] $listBox.Items.Add('CSharp (.Net, Razor, Blazor)')
[void] $listBox.Items.Add('Go ')
[void] $listBox.Items.Add('Mobile Development (React Native)')
[void] $listBox.Items.Add('Node JS')
[void] $listBox.Items.Add('Python ')
[void] $listBox.Items.Add('Web (Html, CSS, Java, Vue? React?)')

$listBox.Height = 70
$form.Controls.Add($listBox)
$form.Topmost = $true
$form.MaximumSize = $form.Size
$form.MinimumSize = $form.Size
$form.MaximizeBox = $false
$form.MinimizeBox = $false

$result = $form.ShowDialog()

$form.Close()

if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{
  foreach ($item in $listBox.SelectedItems) {
    $packageName = $item.Substring(0, $item.IndexOf(' ')).ToLowerInvariant()

    Write-Output "---------> Installing '$packageName' development package..."
    Write-Output " "

    Install-DevVmPackage $packageName
  }
}

Update-AllChocolateyPackages

Set-GitConfigValue -Key "user.email" -Value "julian@julianscorner.com" -Scope Global

if (-not ($(getSetting "FinishBootstrap"))) {
  reg delete HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v Bootstrap /f

  setSetting "FinishBootstrap" $(Get-Date)
}
