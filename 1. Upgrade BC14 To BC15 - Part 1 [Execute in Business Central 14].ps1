###################### Parameters ######################
$DatabaseServer       = "localhost"
$DatabaseName         = "UPG_CustomApp_14_15" 
$ServiceName          = "upgbc140"                        ## Name of Service Mapped to Business Central 14 Database.
$DeveloperLicenseFile = "D:\Blog\Developer License.flf"   ## Developer License
$NavIde = "C:\Program Files (x86)\Microsoft Dynamics 365 Business Central\140\RoleTailored Client\finsql.exe"
######################

Write-Host "1. Importing BC14 Powershell Module"
Import-Module 'C:\Program Files\Microsoft Dynamics 365 Business Central\140\Service\NavAdminTool.ps1'
Import-Module 'C:\Program Files (x86)\Microsoft Dynamics 365 Business Central\140\RoleTailored Client\NavModelTools.ps1'

Write-Host "2. Importing Developer License"
Import-NAVServerLicense -LicenseFile $DeveloperLicenseFile -ServerInstance $ServiceName

Write-Host "3. Disabling Task Scheduler"
Set-NavServerConfiguration -ServerInstance $ServiceName -KeyName "EnableTaskScheduler" -KeyValue false

Write-Host "4. Restarting NAV Service"
Restart-NAVServerInstance -ServerInstance $ServiceName

Write-Host "5. UnInstalling All App Installed on Service"
Get-NAVAppInfo -ServerInstance $ServiceName | % { Uninstall-NAVApp -ServerInstance $ServiceName -Force -Name $_.Name -Version $_.Version}

Write-Host "6. UnPublishing All Symbol on Service"
Get-NAVAppInfo -ServerInstance $ServiceName -SymbolsOnly | % { Unpublish-NAVApp -ServerInstance $ServiceName -Name $_.Name -Version $_.Version }

Write-Host "7. Deleteing Objects Other Than Tables From Database"
Delete-NAVApplicationObject -DatabaseName $DatabaseName -DatabaseServer $DatabaseServer -Filter 'Type=Page|Report|Codeunit|Query|Xmlport|MenuSuite;Id=1..2000000000' -SynchronizeSchemaChanges Force

Write-Host "8. Stopping NAV Service"
Stop-NAVServerInstance -ServerInstance $ServiceName