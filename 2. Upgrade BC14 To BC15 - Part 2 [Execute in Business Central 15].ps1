###################### Parameters ######################
#Replace $DatabaseServer       With SQL Server Name.
#Replace $DatabaseInstance     With SQL Server Instance (if any).
#Replace $DatabaseName         With Database Name. 
#Replace $ServiceName          With Business Central 15 Server Instance Name.
#Replace $DeveloperLicenseFile With File Path of Developer License.
#Replace $BC15Version          With Business Central Base App Version.
#Replace $SystemAppPath        With Actual Path of System App.
#Replace $BaseAppPath          With Actual Path of Base App. [If Custom Base App then replace of Path of that App.]

##################################################################

Write-Host "1. Importing BC15 Powershell Module"
Import-Module 'C:\Program Files\Microsoft Dynamics 365 Business Central\150\Service\NavAdminTool.ps1'

Write-Host "2. Executing Application Database Conversion"
Invoke-NAVApplicationDatabaseConversion -DatabaseName "UPG_CustomApp_14_15" -DatabaseServer "localhost" -Force

Write-Host "3. Checking Service Status and Start if not started"
$ServiceStatus = Get-NAVServerInstance -ServerInstance "BC150Blog"

If ($ServiceStatus.State -eq "Stopped")
{
    Start-NAVServerInstance -ServerInstance "BC150Blog"
}

Write-Host "4. Setting Service Parameters & Load License"
Set-NAVServerConfiguration -ServerInstance "BC150Blog" -KeyName DatabaseServer -KeyValue "localhost"
Set-NAVServerConfiguration -ServerInstance "BC150Blog" -KeyName DatabaseInstance -KeyValue ""
Set-NAVServerConfiguration -ServerInstance "BC150Blog" -KeyName DatabaseName -KeyValue "UPG_CustomApp_14_15"
Set-NavServerConfiguration -ServerInstance "BC150Blog" -KeyName "EnableTaskScheduler" -KeyValue false
Import-NAVServerLicense  -ServerInstance "BC150Blog" -LicenseFile "D:\Blog\Developer License.flf"

Write-Host "5. Restarting NAV Service"
ReStart-NAVServerInstance -ServerInstance "BC150Blog"

Write-Host "6. Publishing System App Symbols"
Publish-NAVApp -ServerInstance "BC150Blog" -Path "C:\Program Files (x86)\Microsoft Dynamics 365 Business Central\150\AL Development Environment\System.app" -PackageType SymbolsOnly

Write-Host "7. Publishing System Application"
Publish-NAVApp -ServerInstance "BC150Blog" -Path "D:\Blog\Microsoft Apps\Microsoft_System Application.app"  -SkipVerification

Write-Host "8. Publishing Base Application"
Publish-NAVApp -ServerInstance "BC150Blog" -Path "D:\Blog\Microsoft Apps\Microsoft-Saurav_Base Application_15.3.40074.40822.app"  -SkipVerification

Write-Host "9. Syncing Tenant"
Sync-NAVTenant -ServerInstance "BC150Blog" -Mode Sync

Write-Host "10. Syncing System Application"
Sync-NAVApp -ServerInstance "BC150Blog" -Name "System Application" -Version 15.3.40074.40822

Write-Host "12. Syncing Base Application"
Sync-NAVApp -ServerInstance "BC150Blog" -Name "Base Application" -Version 15.3.40074.40822

Write-Host "13. Installing System Application"
Install-NAVApp -ServerInstance "BC150Blog" -Name "System Application" -Version 15.3.40074.40822

Write-Host "14. Installing Base Application"
Install-NAVApp -ServerInstance "BC150Blog" -Name "Base Application" -Version 15.3.40074.40822

Write-Host "15. Running Data Upgrade.."
Start-NAVDataUpgrade -ServerInstance "BC150Blog" -FunctionExecutionMode Serial -SkipAppVersionCheck -Force


# Repeat these steps for all Existing Extensions.
Write-Host "16. Upgrade Extension and Uninstall Old Version of App."

# Publish New Version of App.
#Publish-NAVApp -ServerInstance "BC150Blog" -Path "D:\Blog\Other Apps In DVD\ImageAnalysis.app" -SkipVerification

# Sync New Version of App.
#Sync-NAVApp -ServerInstance "BC150Blog" -Name "Image Analyzer" -Version 15.3.40074.40822

# Start NAV Data Upgrade of App.
#Start-NAVAppDataUpgrade -ServerInstance "BC150Blog" -Name "Image Analyzer" -Version 15.3.40074.40822

# Unpublish Old Version of App.
#Unpublish-NAVApp -ServerInstance "BC150Blog" -Name "Image Analyzer" -Version 14.9.39327.0


# Repeat these steps for all New Extension that you need.
Write-Host "17. Install New Extension Avilable with New Version."

# Publish New Version of App.
#Publish-NAVApp -ServerInstance "BC150Blog" -Path "D:\Blog\Other Apps In DVD\Microsoft_Test Runner.app" -SkipVerification

# Sync New App.
#Sync-NAVApp -ServerInstance "BC150Blog" -Name "Test Runner"

# Install New App.
#Install-NAVApp -ServerInstance "BC150Blog" -Name "Test Runner"


Write-Host "18. Get Installed App Information"
Get-NAVAppInfo -ServerInstance "BC150Blog" | format-table appId,Name,publisher

Write-Host "19. Set Properties in Service Tier."
Set-NAVServerConfiguration -ServerInstance "BC150Blog" -KeyName "DestinationAppsForMigration" -KeyValue '[{"appId":"437dbf0e-84ff-417a-965d-ed2bb9650972", "name":"Base Application", "publisher": "Microsoft"}]'

Write-Host "20. Set Other Properties in Service."
Set-NavServerConfiguration -ServerInstance "BC150Blog" -KeyName "EnableTaskScheduler" -KeyValue true

Write-Host "21. Restart NAV Service."
Restart-NAVServerInstance -ServerInstance "BC150Blog"