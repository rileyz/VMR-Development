<#
.SYNOPSIS
    Installs the Application Virtualization (App-V) sequencer from the Windows Assessment and 
    Deployment Kit.
 
.LINK
Author:.......http://www.linkedin.com/in/rileylim
#>



# Script Support ##################################################################################
# Operating System, 32-bit Support, 64-bit Support
# Windows 10,Yes,Yes
# Windows 8.1,No,No
# Windows 8,No,No
# Windows 7,No,No
# Server 2016,NA,Yes
# Server 2012 R2,NA,No
# Server 2012,NA,No
# Server 2008 R2,NA,No
#<<< End of Script Support >>>

# Script Assets ###################################################################################
# Asset: 10.0.14393 32-bit\Appman Sequencer on x86-x86_en-us.msi
# Asset: 10.0.14393 64-bit\Appman Sequencer on amd64-x64_en-us.msi
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

$VersionAndBitness = $([Environment]::GetEnvironmentVariable("VMRWindowsVersion","Machine")) + ' ' + $([Environment]::GetEnvironmentVariable("VMRWindowsArchitecture","Machine"))

Switch ($VersionAndBitness) 
    {'10.0.14393 32-bit'    {$Installer = "$VMRCollateral\$VersionAndBitness\Appman Sequencer on x86-x86_en-us.msi"
                             $ScriptExitResult = (Start-Process -FilePath msiexec.exe -ArgumentList "/i `"$Installer`" AcceptEULA=1 CEIPOPTIN=0 MUOPTIN=0 REBOOT=ReallySuppress /qn" -Wait -Passthru).ExitCode}
     '10.0.14393 64-bit'    {$Installer = "$VMRCollateral\$VersionAndBitness\Appman Sequencer on amd64-x64_en-us.msi"
                             $ScriptExitResult = (Start-Process -FilePath msiexec.exe -ArgumentList "/i `"$Installer`" AcceptEULA=1 CEIPOPTIN=0 MUOPTIN=0 REBOOT=ReallySuppress /qn" -Wait -Passthru).ExitCode}
     Default                {$ArrayScriptExitResult += 'Error'
                             Write-Debug 'No match found!'}}



######Use $ArrayScriptExitResult to capture multiple results and check, otherwise delete.
$ArrayScriptExitResult += $LASTEXITCODE
$ArrayScriptExitResult += $?

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
#End of Use $ArrayScriptExitResult to capture multiple results and check, otherwise delete.

$ScriptExitResult >> $VMRScriptLog

Switch ($ScriptExitResult) 
    {'0'        {VMR_ProcessingModuleComplete -ModuleExitStatus 'Complete'}      #Completed ok.
     'Reboot'   {VMR_ProcessingModuleComplete -ModuleExitStatus 'RebootPending'}
     'Error'    {VMR_ProcessingModuleComplete -ModuleExitStatus 'Error'}
     Default    {VMR_ProcessingModuleComplete -ModuleExitStatus 'Null'
                 Write-Host "The script module was unable to trap exit code for $VMRScriptFile."}}
#<<< End of script work >>>
