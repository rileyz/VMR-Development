﻿<#
.SYNOPSIS
    Installs the Application Virtualization (App-V) service pack or hotfix.
 
.LINK
Author:.......http://www.linkedin.com/in/rileylim
#>



# Script Support ##################################################################################
# Operating System, 32-bit Support, 64-bit Support
# Windows 10,Yes,Yes
# Windows 8.1,Yes,Yes
# Windows 8,Yes,Yes
# Windows 7,Yes,Yes
# Server 2016,NA,No
# Server 2012 R2,NA,Yes
# Server 2012,NA,Yes
# Server 2008 R2,NA,Yes
#<<< End of Script Support >>>

# Script Assets ###################################################################################
# Asset: AppV5.0SP3_Client_KB3139245.exe
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
$ServiceName = 'UI0Detect'
$QueryString = "Select StartMode From Win32_Service Where Name='" + $ServiceName + "'"
$Service = Get-WmiObject -Query $QueryString

If ($Service.StartMode -ne $null)
    {Write-Verbose 'Service $ServiceName present, stopping and disabling service.'
     Stop-Service -Name $ServiceName
     Set-Service -Name $ServiceName -StartupType Disabled}
Else{Write-Verbose 'Service $ServiceName not present.'}

$Process = Start-Process -FilePath $VMRCollateral\AppV5.0SP3_Client_KB3139245.exe -ArgumentList '/q /AcceptEULA /CEIPOPTIN=0 /MUOPTIN=0 /NoRestart' -Wait -PassThru

If ($Service.StartMode -ne $null)
    {Write-Verbose 'Service $ServiceName present, setting Startup Type to Manual.'
     Set-Service -Name $ServiceName -StartupType Manual}
Else{Write-Verbose 'Service $ServiceName not present.'}

($ScriptExitResult = $Process.ExitCode) >> $VMRScriptLog

Switch ($ScriptExitResult) 
    {'0'        {VMR_ProcessingModuleComplete -ModuleExitStatus 'Complete'}      #Completed ok.
     '3010'     {VMR_ProcessingModuleComplete -ModuleExitStatus 'RebootPending'} #Windows Installer: A restart is required to complete the install. 
     '1603'     {VMR_ProcessingModuleComplete -ModuleExitStatus 'Error'}         #Windows Installer: Fatal error during installation.
     'Error'    {VMR_ProcessingModuleComplete -ModuleExitStatus 'Error'}
     Default    {VMR_ProcessingModuleComplete -ModuleExitStatus 'Null'
                 Write-Host "The script module was unable to trap exit code for $VMRScriptFile."}}
#<<< End of script work >>>
