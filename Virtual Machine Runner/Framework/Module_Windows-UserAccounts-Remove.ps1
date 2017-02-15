<#
.SYNOPSIS
    Removes Widnows user accounts.
 
.LINK
Author:.......http://www.linkedin.com/in/rileylim
#>



# Script Support ##################################################################################
# Operating System, 32-bit Support, 64-bit Support
# Windows 10,Yes,Yes
# Windows 8.1,Yes,Yes
# Windows 8,Yes,Yes
# Windows 7,Yes,Yes
# Server 2016,NA,Unproven
# Server 2012 R2,NA,Unproven
# Server 2012,NA,Unproven
# Server 2008 R2,NA,Unproven
#<<< End of Script Support >>>

# Script Assets ###################################################################################
# Asset: UserAccountExceptions.csv
# Asset: GetLocalAccount\GetLocalAccount.ps1
#<<< End of Script Assets >>>



# Setting up housekeeping #########################################################################
$ScriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition
. "$ScriptPath\..\Framework\Core_CommonFunctions.ps1"
$VMRCollateral = VMR_ScriptInformation -CollateralFolder
$VMRScriptLocation = VMR_ScriptInformation -ScriptFolder
$VMRScriptFile = VMR_ScriptInformation -ScriptName
$VMRScriptLog = VMR_ScriptInformation -ScriptLogLocation
VMR_ReadyMessagingEnvironment
#<<< End of Setting up housekeeping >>>



# Start of script work ############################################################################
$ArrayScriptExitResult = @()

(gwmi win32_operatingsystem -ComputerName localhost).Win32Shutdown(4)

Do {$Explorer = Get-Process Explorer -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 1}
    Until ($Explorer -eq $null)

Start-Sleep -Seconds 30

$DataCVS = "$VMRCollateral\UserAccountExceptions.csv" 
$UserAccountExceptionsArray = (Import-Csv $DataCVS -Header UserNames)[1..($DataCVS.length - 1)]

$LocalUserAccountsArray = &"$VMRCollateral\GetLocalAccount\GetLocalAccount.ps1"

ForEach ($LocalAccount in $LocalUserAccountsArray) 
    {$DoNotDelete = $null
     $LocalAccountName = $LocalAccount.Name 
     $LocalAccountName >> $VMRScriptLog

     ForEach ($AccountException in $UserAccountExceptionsArray)
         {If (($LocalAccountName -replace "`n|`r")  -eq ($AccountException -replace "@{UserNames=|}|`n|`r"))
                {$DoNotDelete = $true}}
     
     If ($DoNotDelete -eq $true)
             {' Not to be deleted.' >> $VMRScriptLog}
         Else{' To be deleted.' >> $VMRScriptLog
              $User = Get-WmiObject Win32_UserProfile -filter "localpath='C:\\Users\\$LocalAccountName'"
              $User.Delete()
              $ArrayScriptExitResult += $?
      
              &net User `"$LocalAccountName`" /Delete}
              $ArrayScriptExitResult += $LASTEXITCODE}

$SuccessCodes = @('Example','0','3010','True')                                                    #List all success codes, including reboots here.
$SuccessButNeedsRebootCodes = @('Example','3010')                                                 #List success but needs reboot code here.
$ScriptError = $ArrayScriptExitResult | Where-Object {$SuccessCodes -notcontains $_}              #Store errors found in this variable
$ScriptReboot = $ArrayScriptExitResult | Where-Object {$SuccessButNeedsRebootCodes -contains $_}  #Store success but needs reboot in this variable

If ($ScriptError -eq $null)                       #If ScriptError is empty, then everything processed ok.
        {If ($ScriptReboot -ne $null)             #If ScriptReboot is not empty, then everything processed ok, but just needs a reboot.
                {$ScriptExitResult = 'Reboot'}
            Else{$ScriptExitResult = '0'}}
    Else{$ScriptExitResult = 'Error'
         $ScriptError >> $VMRScriptLog}

$ScriptExitResult >> $VMRScriptLog

Switch ($ScriptExitResult) 
    {'0'        {VMR_ProcessingModuleComplete -ModuleExitStatus 'Complete'}
     'Reboot'   {VMR_ProcessingModuleComplete -ModuleExitStatus 'RebootPending'}
     'Error'    {VMR_ProcessingModuleComplete -ModuleExitStatus 'Error'}
     Default    {VMR_ProcessingModuleComplete -ModuleExitStatus 'Null'
                 Write-Host "The script module was unable to trap exit code for $VMRScriptFile."}}
#<<< End of script work >>>
