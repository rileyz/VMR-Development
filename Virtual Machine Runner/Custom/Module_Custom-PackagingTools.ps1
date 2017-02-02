﻿<#
.SYNOPSIS
    Creates a folder name Tools in C:\ with a shortcut on the desktop, the folder contains common
    tools used in application virtualisation, repackaging and packaging.
 
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
# None
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
New-Item -Path 'C:\Tools' -ItemType Directory
Copy-Item -Path "$VMRCollateral\*" -Destination 'C:\Tools' -Recurse

$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("C:\Users\$env:username\Desktop\Tools.lnk")
$Shortcut.TargetPath = "C:\Tools"
$Shortcut.Save()

If ((Test-Path C:\Tools) -eq $true -and (Test-Path "C:\Users\$env:username\Desktop\Tools.lnk") -eq $true)
        {$ScriptExitResult = 0}

$ScriptExitResult >> $VMRScriptLog

Switch ($ScriptExitResult) 
    {'0'        {VMR_ProcessingModuleComplete -ModuleExitStatus 'Complete'}      #Completed ok.
     'Reboot'   {VMR_ProcessingModuleComplete -ModuleExitStatus 'RebootPending'}
     'Error'    {VMR_ProcessingModuleComplete -ModuleExitStatus 'Error'}
     Default    {VMR_ProcessingModuleComplete -ModuleExitStatus 'Null'
                 Write-Host "The script module was unable to trap exit code for $VMRScriptFile."}}
#<<< End of script work >>>
