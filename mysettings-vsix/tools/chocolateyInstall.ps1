$packageName = "mysettings-vsix"
$vsgallery = "https://visualstudiogallery.msdn.microsoft.com"

Install-ChocolateyVsixPackage "vscoloroutput" `
    "$vsgallery/f4d9c2b5-d6d7-4543-a7a5-2d7ebabc2496/file/63103/18/VSColorOutput.vsix"

Install-ChocolateyVsixPackage "webextensionpack" `
    "$vsgallery/f3b504c6-0095-42f1-a989-51d5fc2a8459/file/186606/19/Web%20Extension%20Pack%20v1.4.43.vsix"

Install-ChocolateyVsixPackage "ihateregions" `
    "$vsgallery/0ca60d35-1e02-43b7-bf59-ac7deb9afbca/file/69113/8/DisableRegions.vsix"

Install-ChocolateyVsixPackage "productivitypowertools" `
    "$vsgallery/34ebc6a2-2777-421d-8914-e29c1dfa7f5d/file/169971/1/ProPowerTools.vsix"

Install-ChocolateyVsixPackage "gitdiffmargin" `
    "$vsgallery/cf49cf30-2ca6-4ea0-b7cc-6a8e0dadc1a8/file/101267/14/GitDiffMargin.vsix"

Install-ChocolateyVsixPackage "codemaid" `
    "$vsgallery/76293c4d-8c16-4f4a-aee6-21f83a571496/file/9356/37/CodeMaid%20v10.1.93.vsix"

Install-ChocolateyVsixPackage "sqlitetoolbox" `
    "$vsgallery/0e313dfd-be80-4afb-b5e9-6e74d369f7a1/file/29445/85/SqlCeToolbox.4.5.0.3.vsix"

Install-ChocolateyVsixPackage "stylecop" `
    "$vsgallery/cac2a05b-6eb6-4fa2-95b9-1f8d011e6cae/file/173746/14/VSIXPackage.vsix"

Install-ChocolateyVsixPackage "slowcheetah" `
    "$vsgallery/05bb50e3-c971-4613-9379-acae2cfe6f9e/file/171400/1/SlowCheetah.vsix"

Install-ChocolateyVsixPackage "powershelltools" `
    "$vsgallery/c9eb3ba8-0c59-4944-9a62-6eee37294597/file/199313/3/PowerShellTools.14.0.vsix"
