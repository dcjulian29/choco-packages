function installPackage($Package) {
  if ($(getSetting $Package)) {
    return
  }

  Write-Output "---> Starting Install of $Package..."

  Install-DevVmPackage $Package
  setSettings $Package "$(Get-Date)"

  Start-Sleep -Seconds 5
}

function getSettingsFile {
  if (-not (Test-Path "${env:TEMP}\julian-bootstrap.json")) {
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

  $settings | ConvertTo-Json | Out-File "${env:TEMP}\julian-bootstrap.json"
}

#------------------------------------------------------------------------------

Start-Transcript "$(Get-LogFileName -Suffix "$env:COMPUTERNAME-bootstrap")"

if ((getSetting "FinishBootstrap") -eq "Yes" ) {
  Write-Warning "This bootstrap script has completed and should be removed from auto run."
  Start-Sleep -Seconds 30
  exit
}

if (-not ($(getSetting "BootstrapStarted") -eq "Yes" )) {
  setSettings "BootstrapStarted" "Yes"
}

@(
  "mytools-scm"
  "mytools-personal"
  "mytools-database"
  "mydevices-devvm"
) | ForEach-Object { installPackage $_ }

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Select Development Packages'
$form.Size = New-Object System.Drawing.Size(300, 230)

$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Point(75,150)
$OKButton.Size = New-Object System.Drawing.Size(75,23)
$OKButton.Text = 'OK'
$OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $OKButton
$form.Controls.Add($OKButton)

$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Point(150,150)
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

$listBox.Height = 100
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
    installPackage ("dev-" + $item.Substring(0, $item.IndexOf(' ')).ToLowerInvariant())
  }
}

Update-AllChocolateyPackages

Set-GitConfigValue -Key "user.email" -Value "julian@julianscorner.com" -Scope Global

if (-not ($(getSetting "FinishBootstrap"))) {

  Write-Output "Turning back on UAC..."
  reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v EnableLUA /t REG_DWORD /d 1 /f

  Write-Output "Removing auto-logon from registry..."
  reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AutoAdminLogon /f
  reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AutoLogonCount /f
  reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AutoLogonSID /f
  reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultDomainName /f
  reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultUserName /f

  Write-Output "Removing bootstrap script from registry..."
  reg delete HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v Bootstrap /f

  setSettings "FinishBootstrap" $(Get-Date)
}

Stop-Transcript