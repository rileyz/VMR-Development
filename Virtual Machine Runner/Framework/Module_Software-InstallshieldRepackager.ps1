﻿<#
.SYNOPSIS
    Installs Installshield Repackager 5.
    
    Download and information available via the links below.
    https://technet.microsoft.com/en-us/library/bb490284.aspx?f=255&MSPPError=-2147217396
    http://leinss.com/blog/?p=240
 
.LINK
Author:.......http://www.linkedin.com/in/rileylim
#>



# Script Support ##################################################################################
# Operating System, 32-bit Support, 64-bit Support
# Windows 10,Yes,Yes
# Windows 8.1,Yes,Yes
# Windows 8,Yes,Yes
# Windows 7,Yes,Yes
# Server 2016,NA,Yes
# Server 2012 R2,NA,Yes
# Server 2012,NA,Yes
# Server 2008 R2,NA,Yes
#<<< End of Script Support >>>

# Script Assets ###################################################################################
# Asset: InstallShield Repackager.msi
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
$Installer = "$VMRCollateral\InstallShield Repackager.msi"

$ScriptExitResult = (Start-Process -FilePath msiexec.exe -ArgumentList "/i `"$Installer`" USERNAME=`"Repackager User`" /qn" -Wait -Passthru).ExitCode

$ScriptExitResult >> $VMRScriptLog

Switch ($ScriptExitResult) 
    {'0'        {VMR_ProcessingModuleComplete -ModuleExitStatus 'Complete'}      #Completed ok.
     'Reboot'   {VMR_ProcessingModuleComplete -ModuleExitStatus 'RebootPending'}
     'Error'    {VMR_ProcessingModuleComplete -ModuleExitStatus 'Error'}
     Default    {VMR_ProcessingModuleComplete -ModuleExitStatus 'Null'
                 Write-Host "The script module was unable to trap exit code for $VMRScriptFile."}}
#<<< End of script work >>>
