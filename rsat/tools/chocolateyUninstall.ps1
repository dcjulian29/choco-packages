$packageName = "rsat8"

& dism.exe /online /disable-feature `
    /featurename:RemoteServerAdministrationTools `
    /featurename:RemoteServerAdministrationTools-Roles `
    /featurename:RemoteServerAdministrationTools-Roles-CertificateServices `
    /featurename:RemoteServerAdministrationTools-Roles-CertificateServices-CA `
    /featurename:RemoteServerAdministrationTools-Roles-AD `
    /featurename:RemoteServerAdministrationTools-Roles-AD-DS `
    /featurename:RemoteServerAdministrationTools-Roles-AD-DS-SnapIns `
    /featurename:RemoteServerAdministrationTools-Roles-AD-DS-AdministrativeCenter `
    /featurename:RemoteServerAdministrationTools-Roles-AD-LDS `
    /featurename:RemoteServerAdministrationTools-Roles-AD-Powershell `
    /featurename:RemoteServerAdministrationTools-Roles-DHCP `
    /featurename:RemoteServerAdministrationTools-Roles-DNS `
    /featurename:RemoteServerAdministrationTools-Roles-FileServices `
    /featurename:RemoteServerAdministrationTools-Roles-FileServices-Dfs `
    /featurename:RemoteServerAdministrationTools-Roles-FileServices-Fsrm `
    /featurename:RemoteServerAdministrationTools-Roles-FileServices-StorageMgmt `
    /featurename:RemoteServerAdministrationTools-Roles-HyperV `
    /featurename:RemoteServerAdministrationTools-Features `
    /featurename:RemoteServerAdministrationTools-Features-Clustering `
    /featurename:RemoteServerAdministrationTools-Features-GP `
    /featurename:RemoteServerAdministrationTools-Features-LoadBalancing `
    /featurename:RemoteServerAdministrationTools-Features-StorageExplorer `
    /featurename:RemoteServerAdministrationTools-Features-StorageManager `
    /featurename:RemoteServerAdministrationTools-Features-Wsrm
