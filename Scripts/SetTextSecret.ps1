Import-Module navcontainerhelper
Invoke-NavContainerCodeunit `
-containerName bcsandbox `
-CompanyName "CRONUS USA, Inc." `
-Codeunitid 60260 `
-MethodName SetSecretValue `
-Argument "UHZJ7+k]Lt0[Mw3[@hyA)G_t%"

Invoke-NavContainerCodeunit `
-containerName bcsandbox `
-CompanyName "CRONUS USA, Inc." `
-Codeunitid 60260 `
-MethodName PrepareSecretValueTableForExport

Enter-BCContainer -containerName bcsandbox
Export-NAVAppTableData -ServerInstance BC -Path C:\ProgramData\navcontainerhelper\SecretValue -TableId 60250 -Force
Exit-PSSession

Invoke-NavContainerCodeunit `
-containerName bcsandbox `
-CompanyName "CRONUS USA, Inc." `
-Codeunitid 60260 `
-MethodName RemoveSecretValueTableData

Copy-Item -Path "C:\ProgramData\navcontainerhelper\SecretValue\TAB60250.navxdata" -Destination "..\DemoSecretValues\Data" -Force