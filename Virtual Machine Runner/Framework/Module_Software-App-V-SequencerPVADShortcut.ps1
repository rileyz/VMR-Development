﻿<#
.SYNOPSIS
    Creates a shortcut for Sequencer enabled PVAD.
 
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
If (Test-Path 'C:\Program Files\Microsoft Application Virtualization\Sequencer\Sequencer.exe')
        {$Target = 'C:\Program Files\Microsoft Application Virtualization\Sequencer\Sequencer.exe'
         $Shortcut = 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Application Virtualization Sequencer\Squencer with PVAD Enabled.lnk'

         $WshShell = New-Object -comObject WScript.Shell
         $Shortcut = $WshShell.CreateShortcut("$Shortcut")
         $Shortcut.Arguments = '-EnablePVADControl'
         $Shortcut.IconLocation = "$Target, 2"
         $Shortcut.TargetPath = "$Target"
         $Shortcut.Save()
         
         If (Test-Path $Shortcut){$ArrayScriptExitResult += 0}}

If (Test-Path 'C:\Program Files\Windows Kits\10\Microsoft Application Virtualization\Sequencer\Sequencer.exe')
        {$Target = 'C:\Program Files\Windows Kits\10\Microsoft Application Virtualization\Sequencer\Sequencer.exe'
         $Shortcut = 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Windows Kits\Windows ADK\Squencer with PVAD Enabled.lnk'

         $WshShell = New-Object -comObject WScript.Shell
         $Shortcut = $WshShell.CreateShortcut("$Shortcut")
         $Shortcut.Arguments = '-EnablePVADControl'
         $Shortcut.IconLocation = "$Target, 2"
         $Shortcut.TargetPath = "$Target"
         $Shortcut.Save()
         
         If (Test-Path $Shortcut){$ArrayScriptExitResult += 0}}

If ($ScriptError -eq $null)                       #If ScriptError is empty, then everything processed ok.
        {If ($ScriptReboot -ne $null)             #If ScriptReboot is not empty, then everything processed ok, but just needs a reboot.
                {$ScriptExitResult = 'Reboot'}
            Else{$ScriptExitResult = '0'}}
    Else{$ScriptExitResult = 'Error'
         $ScriptError >> $VMRScriptLog}

$ScriptExitResult >> $VMRScriptLog

Switch ($ScriptExitResult) 
    {'0'        {VMR_ProcessingModuleComplete -ModuleExitStatus 'Complete'}      #Completed ok.
     'Reboot'   {VMR_ProcessingModuleComplete -ModuleExitStatus 'RebootPending'}
     'Error'    {VMR_ProcessingModuleComplete -ModuleExitStatus 'Error'}
     Default    {VMR_ProcessingModuleComplete -ModuleExitStatus 'Null'
                 Write-Host "The script module was unable to trap exit code for $VMRScriptFile."}}
#<<< End of script work >>>
