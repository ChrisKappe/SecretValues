Import-Module navcontainerhelper
Invoke-NavContainerCodeunit `
-containerName bcsandbox `
-CompanyName "CRONUS USA, Inc." `
-Codeunitid 70455527 `
-MethodName SetSecretValue `
-Argument "UHZJ7+k]Lt0[Mw3[@hyA)G_t%"

Invoke-NavContainerCodeunit `
-containerName bcsandbox `
-CompanyName "CRONUS USA, Inc." `
-Codeunitid 70455527 `
-MethodName PrepareSecretValueTableForExport

Enter-BCContainer -containerName bcsandbox
Export-NAVAppTableData -ServerInstance BC -Path C:\ProgramData\navcontainerhelper\SecretValue -TableId 70455525 -Force
Exit-PSSession

Invoke-NavContainerCodeunit `
-containerName bcsandbox `
-CompanyName "CRONUS USA, Inc." `
-Codeunitid 70455527 `
-MethodName RemoveSecretValueTableData

Copy-Item -Path "C:\ProgramData\navcontainerhelper\SecretValue\TAB70455525.navxdata" -Destination "..\App\Data" -Force