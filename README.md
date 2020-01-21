# Introduction 
This is a project to contain Test PowerShell cmdlets. 

# Getting Started
* Create a credential from your Credential Manager

![Windows Credentials](./git01.png)

* SPFxInventory: this is PS to list SPFx usage for site collection
  ```PowerShell
  # switch PnP Powershell to SPO
  .\Get-SPFxInventory.ps1 -csvFile [csvFile] -credStoreName [CredentialStorageName] -spoAdminUrl [https://tenant-admin.sharepoint.com]
  
  ```
* NOTE: if you are using a account required MFA, you need to use different authentication.
