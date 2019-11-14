#Replace <<BC14Service>> With Business Central 14 Service Instance Name
#Replace <<BC15Service>> With Business Central 15 Service Instance Name
#Replace <<DBName>>      With Database Name
#Replace <<ServerName>>  With SQL Server name
#Replace 15.0.36560.36649 with BC15 Base App Version

#1. Import BC14 Powershell Module
Import-Module 'C:\Program Files\Microsoft Dynamics 365 Business Central\140\Service\NavAdminTool.ps1'

#2. UnInstall All App Installed on Service
Get-NAVAppInfo -ServerInstance <<BC14Service>> | % { Uninstall-NAVApp -ServerInstance <<BC14Service>> -Name $_.Name -Version $_.Version}

#3. UnPublish All Symbol on Service
Get-NAVAppInfo -ServerInstance <<BC14Service>> -SymbolsOnly | % { Unpublish-NAVApp -ServerInstance <<BC14Service>> -Name $_.Name -Version $_.Version }

#4. Stop NAV Service
Stop-NAVServerInstance -ServerInstance <<BC14Service>>

## Close and Start Powershell again before procedding.

#5. Import BC15 Powershell Module
Import-Module 'C:\Program Files\Microsoft Dynamics 365 Business Central\150\Service\NavAdminTool.ps1'

#6. Invoke Application Database Conversion
Invoke-NAVApplicationDatabaseConversion -DatabaseName <<DBName>> -DatabaseServer <<ServerName>>

#7. Set Database Name
Set-NAVServerConfiguration -ServerInstance <<BC15Service>> -KeyName DatabaseName -KeyValue <<DBName>>

#8. Disable Task Scheduler
Set-NavServerConfiguration -ServerInstance <<BC15Service>> -KeyName "EnableTaskScheduler" -KeyValue false

#9. Restart Service
Restart-NAVServerInstance -ServerInstance <<BC15Service>> 

#10. Publish System App Symbols
Publish-NAVApp -ServerInstance <<BC15Service>> -Path "C:\Program Files (x86)\Microsoft Dynamics 365 Business Central\150\AL Development Environment\System.app" -PackageType SymbolsOnly

#11. Publish Microsoft System App.
#Change Path as the Path of System Application.
Publish-NAVApp -ServerInstance <<BC15Service>> -Path "D:\Wave 2 DVD\Applications\System Application\Source\Microsoft_System Application.app"

#12. Publish Microsoft Base App.
#Change Path as the Path of Base Application.
Publish-NAVApp -ServerInstance <<BC15Service>> -Path "D:\Wave 2 DVD\Applications\BaseApp\Source\Microsoft_Base Application.app"

#13. Sync NavTenant 
Sync-NAVTenant -ServerInstance <<BC15Service>> -Mode Sync

#14. Get Version for System and Base Application
Get-NAVAppInfo -ServerInstance <<BC15Service>>

#15. Sync System Application
Sync-NAVApp -ServerInstance <<BC15Service>> -Name "System Application" -Version 15.0.36560.36649 

#16. Sync Base Application
Sync-NAVApp -ServerInstance <<BC15Service>> -Name "Base Application" -Version 15.0.36560.36649

#17. Install System Application
Install-NAVApp -ServerInstance <<BC15Service>> -Name "System Application" -Version 15.0.36560.36649

#18. Install Base Application
Install-NAVApp -ServerInstance <<BC15Service>> -Name "Base Application" -Version 15.0.36560.36649

#19. Run Data Upgrade.
Start-NAVDataUpgrade -ServerInstance <<BC15Service>> -FunctionExecutionMode Serial -SkipAppVersionCheck -Force

#20. Progress of Data Upgrade. (optional)
Get-NAVDataUpgrade -ServerInstance <<BC15Service>> -Detailed | Out-GridView

#21. List Installed Extension with Version
Get-NAVAppInfo -ServerInstance <<BC15Service>> | format-table Name,version


#22. Publish, Sync and Upgrade App from Product DVD (Only those who exist)

# Essential Business Headlines
#Replace Path With Actual Path of App.
Publish-NAVApp -ServerInstance <<BC15Service>> -Path "D:\Wave 2 DVD\Applications\EssentialBusinessHeadlines\Source\EssentialBusinessHeadlines.app" -SkipVerification
Sync-NAVApp -ServerInstance <<BC15Service>> -Name "Essential Business Headlines" -Version 15.0.36560.36649
Start-NAVAppDataUpgrade -ServerInstance <<BC15Service>> -Name "Essential Business Headlines" -Version 15.0.36560.36649

# Envestnet Yodlee Bank Feeds
#Replace Path With Actual Path of App.
Publish-NAVApp -ServerInstance <<BC15Service>> -Path "D:\Wave 2 DVD\Applications\EnvestnetYodleeBankFeeds\Source\EnvestnetYodleeBankFeeds.app" -SkipVerification
Sync-NAVApp -ServerInstance <<BC15Service>> -Name "Envestnet Yodlee Bank Feeds" -Version 15.0.36560.36649
Start-NAVAppDataUpgrade -ServerInstance <<BC15Service>> -Name "Envestnet Yodlee Bank Feeds" -Version 15.0.36560.36649

# Quickbooks Payroll File Import
#Replace Path With Actual Path of App.
Publish-NAVApp -ServerInstance <<BC15Service>> -Path "D:\Wave 2 DVD\Applications\QuickbooksPayrollFileImport\Source\QuickbooksPayrollFileImport.app" -SkipVerification
Sync-NAVApp -ServerInstance <<BC15Service>> -Name "Quickbooks Payroll File Import" -Version 15.0.36560.36649
Start-NAVAppDataUpgrade -ServerInstance <<BC15Service>> -Name "Quickbooks Payroll File Import" -Version 15.0.36560.36649

# Image Analyzer
#Replace Path With Actual Path of App.
Publish-NAVApp -ServerInstance <<BC15Service>> -Path "D:\Wave 2 DVD\Applications\ImageAnalysis\Source\ImageAnalysis.app" -SkipVerification
Sync-NAVApp -ServerInstance <<BC15Service>> -Name "Image Analyzer" -Version 15.0.36560.36649
Start-NAVAppDataUpgrade -ServerInstance <<BC15Service>> -Name "Image Analyzer" -Version 15.0.36560.36649

# Sales and Inventory Forecast
#Replace Path With Actual Path of App.
Publish-NAVApp -ServerInstance <<BC15Service>> -Path "D:\Wave 2 DVD\Applications\SalesAndInventoryForecast\Source\SalesAndInventoryForecast.app" -SkipVerification
Sync-NAVApp -ServerInstance <<BC15Service>> -Name "Sales and Inventory Forecast" -Version 15.0.36560.36649
Start-NAVAppDataUpgrade -ServerInstance <<BC15Service>> -Name "Sales and Inventory Forecast" -Version 15.0.36560.36649

# Send remittance advice by email
#Replace Path With Actual Path of App.
Publish-NAVApp -ServerInstance <<BC15Service>> -Path "D:\Wave 2 DVD\Applications\UKSendRemittanceAdvice\Source\UKSendRemittanceAdvice.app" -SkipVerification
Sync-NAVApp -ServerInstance <<BC15Service>> -Name "Send remittance advice by email" -Version 15.0.36560.36649
Start-NAVAppDataUpgrade -ServerInstance <<BC15Service>> -Name "Send remittance advice by email" -Version 15.0.36560.36649

# Ceridian Payroll
#Replace Path With Actual Path of App.
Publish-NAVApp -ServerInstance <<BC15Service>> -Path "D:\Wave 2 DVD\Applications\Ceridian\Source\Ceridian.app" -SkipVerification
Sync-NAVApp -ServerInstance <<BC15Service>> -Name "Ceridian Payroll" -Version 15.0.36560.36649
Start-NAVAppDataUpgrade -ServerInstance <<BC15Service>> -Name "Ceridian Payroll" -Version 15.0.36560.36649

# PayPal Payments Standard
#Replace Path With Actual Path of App.
Publish-NAVApp -ServerInstance <<BC15Service>> -Path "D:\Wave 2 DVD\Applications\PayPalPaymentsStandard\Source\PayPalPaymentsStandard.app" -SkipVerification
Sync-NAVApp -ServerInstance <<BC15Service>> -Name "PayPal Payments Standard" -Version 15.0.36560.36649
Start-NAVAppDataUpgrade -ServerInstance <<BC15Service>> -Name "PayPal Payments Standard" -Version 15.0.36560.36649

# Client Addins
#Replace Path With Actual Path of App.
Publish-NAVApp -ServerInstance <<BC15Service>> -Path "D:\Wave 2 DVD\Applications\ClientAddIns\Source\ClientAddIns.app" -SkipVerification
Sync-NAVApp -ServerInstance <<BC15Service>> -Name "_Exclude_ClientAddIns_" -Version 15.0.36560.36649
Start-NAVAppDataUpgrade -ServerInstance <<BC15Service>> -Name "_Exclude_ClientAddIns_" -Version 15.0.36560.36649

# APIV1
#Replace Path With Actual Path of App.
Publish-NAVApp -ServerInstance <<BC15Service>> -Path "D:\Wave 2 DVD\Applications\APIV1\Source\APIV1.app" -SkipVerification
Sync-NAVApp -ServerInstance <<BC15Service>> -Name "_Exclude_APIV1_" -Version 15.0.36560.36649
Start-NAVAppDataUpgrade -ServerInstance <<BC15Service>> -Name "_Exclude_APIV1_" -Version 15.0.36560.36649

# Intelligent Cloud Base
#Replace Path With Actual Path of App.
Publish-NAVApp -ServerInstance <<BC15Service>> -Path "D:\Wave 2 DVD\Applications\HybridBaseDeployment\Source\HybridBaseDeployment.app" -SkipVerification
Sync-NAVApp -ServerInstance <<BC15Service>> -Name "Intelligent Cloud Base" -Version 15.0.36560.36649
Start-NAVAppDataUpgrade -ServerInstance <<BC15Service>> -Name "Intelligent Cloud Base" -Version 15.0.36560.36649

# Business Central Intelligent Cloud
#Replace Path With Actual Path of App.
Publish-NAVApp -ServerInstance <<BC15Service>> -Path "D:\Wave 2 DVD\Applications\HybridBC\Source\HybridBC.app" -SkipVerification
Sync-NAVApp -ServerInstance <<BC15Service>> -Name "Business Central Intelligent Cloud" -Version 15.0.36560.36649
Start-NAVAppDataUpgrade -ServerInstance <<BC15Service>> -Name "Business Central Intelligent Cloud" -Version 15.0.36560.36649


#23. UnPublish old Version of App from Product DVD (Only those who exist)
Unpublish-NAVApp -ServerInstance <<BC15Service>> -Name "Essential Business Headlines" -Version 14.5.35970.0
Unpublish-NAVApp -ServerInstance <<BC15Service>> -Name "Envestnet Yodlee Bank Feeds" -Version 14.5.35970.0
Unpublish-NAVApp -ServerInstance <<BC15Service>> -Name "Quickbooks Payroll File Import" -Version 14.5.35970.0
Unpublish-NAVApp -ServerInstance <<BC15Service>> -Name "Image Analyzer" -Version 14.5.35970.0
Unpublish-NAVApp -ServerInstance <<BC15Service>> -Name "Sales and Inventory Forecast" -Version 14.5.35970.0
Unpublish-NAVApp -ServerInstance <<BC15Service>> -Name "Send remittance advice by email" -Version 14.5.35970.0
Unpublish-NAVApp -ServerInstance <<BC15Service>> -Name "Ceridian Payroll" -Version 14.5.35970.0
Unpublish-NAVApp -ServerInstance <<BC15Service>> -Name "PayPal Payments Standard" -Version 14.5.35970.0
Unpublish-NAVApp -ServerInstance <<BC15Service>> -Name "_Exclude_ClientAddIns_" -Version 14.5.35970.0
Unpublish-NAVApp -ServerInstance <<BC15Service>> -Name "_Exclude_APIV1_" -Version 14.5.35970.0
Unpublish-NAVApp -ServerInstance <<BC15Service>> -Name "Intelligent Cloud Base" -Version 14.5.35970.0
Unpublish-NAVApp -ServerInstance <<BC15Service>> -Name "Business Central Intelligent Cloud" -Version 14.5.35970.0

#24. Publish, Sync and Install Microsoft Apps.
#Replace Path With Actual Path of App.
Publish-NAVApp -ServerInstance <<BC15Service>> -Path "D:\Wave 2 DVD\Applications\AMCBanking365Fundamentals\Source\AMCBanking365Fundamentals.app" -SkipVerification
Sync-NAVApp -ServerInstance <<BC15Service>> -Name "AMC Banking 365 Fundamentals" 
Install-NAVApp -ServerInstance <<BC15Service>> -Name "AMC Banking 365 Fundamentals"

Publish-NAVApp -ServerInstance <<BC15Service>> -Path "D:\Wave 2 DVD\Applications\TestFramework\TestLibraries\Any\Microsoft_Any.app" -SkipVerification
Sync-NAVApp -ServerInstance <<BC15Service>> -Name "Any"
Install-NAVApp -ServerInstance <<BC15Service>> -Name "Any"

Publish-NAVApp -ServerInstance <<BC15Service>> -Path "D:\Wave 2 DVD\Applications\TestFramework\TestLibraries\Assert\Microsoft_Library Assert.app" -SkipVerification
Sync-NAVApp -ServerInstance <<BC15Service>> -Name "Library Assert"
Install-NAVApp -ServerInstance <<BC15Service>> -Name "Library Assert"

Publish-NAVApp -ServerInstance <<BC15Service>> -Path "D:\Wave 2 DVD\Applications\TestFramework\TestRunner\Microsoft_Test Runner.app" -SkipVerification
Sync-NAVApp -ServerInstance <<BC15Service>> -Name "Test Runner"
Install-NAVApp -ServerInstance <<BC15Service>> -Name "Test Runner"

#25. Get Base App Properties.
Get-NAVAppInfo -ServerInstance <<BC15Service>> | format-table appId,Name,publisher

#26. Set the DestinationAppsForMigration parameter for the server instance configuration to include the information about the base application.
Set-NAVServerConfiguration -ServerInstance <<BC15Service>> -KeyName "DestinationAppsForMigration" -KeyValue '[{"appId":"437dbf0e-84ff-417a-965d-ed2bb9650972", "name":"Base Application", "publisher": "Microsoft"}]'

#27. Restart Service
Restart-NAVServerInstance -ServerInstance <<BC15Service>> 

################################## This Section only Applies to Custom Extension in your database. ################################

#28. Sync Published Extension
Sync-NAVApp -ServerInstance <<BC15Service>> -Name "Purchase Quote Expiry" -Version 1.0.0.0
Sync-NAVApp -ServerInstance <<BC15Service>> -Name "Report Logger" -Version 1.0.0.0
Sync-NAVApp -ServerInstance <<BC15Service>> -Name "Grouped Invoice" -Version 1.0.0.0
Sync-NAVApp -ServerInstance <<BC15Service>> -Name "Item Brands" -Version 1.0.0.0

#29. Install Extesnions.
Install-NAVApp -ServerInstance <<BC15Service>> -Name "Purchase Quote Expiry" -Version 1.0.0.0
Install-NAVApp -ServerInstance <<BC15Service>> -Name "Report Logger" -Version 1.0.0.0
Install-NAVApp -ServerInstance <<BC15Service>> -Name "Grouped Invoice" -Version 1.0.0.0
Install-NAVApp -ServerInstance <<BC15Service>> -Name "Item Brands" -Version 1.0.0.0

################################## This Section only Applies to Custom Extension in your database. ################################

#30. Enable TaskScheduler and Restart Service.
Set-NavServerConfiguration -ServerInstance <<BC15Service>> -KeyName "EnableTaskScheduler" -KeyValue true
Restart-NAVServerInstance -ServerInstance <<BC15Service>>
