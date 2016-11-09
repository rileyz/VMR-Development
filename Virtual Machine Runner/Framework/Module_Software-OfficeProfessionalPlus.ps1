<#
.SYNOPSIS
    Installs Office Professional Plus 2013/2016 with generic volume licence keys.
 
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



# Setting up housekeeping #########################################################################
Param([String]$Version)
$ScriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition
. "$ScriptPath\..\Framework\Core_CommonFunctions.ps1"
$VMRCollateral = VMR_ScriptInformation -CollateralFolder
$VMRScriptLocation = VMR_ScriptInformation -ScriptFolder
$VMRScriptFile = VMR_ScriptInformation -ScriptName
$VMRScriptLog = VMR_ScriptInformation -ScriptLogLocation
VMR_ReadyMessagingEnvironment
#<<< End of Setting up housekeeping >>>



# Start of script work ############################################################################
If ($Version -eq 'DoNotInstall')
        {Write-Output 'Not installing Office.'
         $ScriptExitResult = '0'}
    Else{Switch ($Version)
             {'Office2013_32'    {Start-Process -FilePath $VMRCollateral\SW_DVD5_Office_Professional_Plus_2013_W32_English_MLF_X18-55138.ISO\setup.exe -ArgumentList "/Config $VMRCollateral\OfficeProPlusConfiguration.xml" -Wait}
              'Office2013_64'    {Start-Process -FilePath $VMRCollateral\SW_DVD5_Office_Professional_Plus_2013_64Bit_English_MLF_X18-55297.ISO\setup.exe -ArgumentList "/Config $VMRCollateral\OfficeProPlusConfiguration.xml" -Wait}
              'Office2016_32'    {Start-Process -FilePath $VMRCollateral\SW_DVD5_Office_Professional_Plus_2016_W32_English_MLF_X20-41353.ISO\setup.exe -ArgumentList "/Config $VMRCollateral\OfficeProPlusConfiguration.xml" -Wait}
              'Office2016_64'    {Start-Process -FilePath $VMRCollateral\SW_DVD5_Office_Professional_Plus_2016_64Bit_English_MLF_X20-42432.ISO\setup.exe -ArgumentList "/Config $VMRCollateral\OfficeProPlusConfiguration.xml" -Wait}
               Default           {"Switch statement was unable to determine selection: $Version" >> $VMRScriptLog
                                  $ScriptExitResult = 'Error'}}

         $OfficeLog = Get-Content -Path "$env:WinDir\Temp\OfficeProfessionalPlus.log"

         If ($OfficeLog -match 'Successfully installed package: ProPlus.*?-C\\ProPlus.?WW.msi')
                 {$ScriptExitResult = '0'}
             Else{$ScriptExitResult = 'Error'}}

$ScriptExitResult >> $VMRScriptLog

Switch ($ScriptExitResult) 
    {'0'        {VMR_ProcessingModuleComplete -ModuleExitStatus 'Complete'}      #Completed ok.
     'Reboot'   {VMR_ProcessingModuleComplete -ModuleExitStatus 'RebootPending'}
     'Error'    {VMR_ProcessingModuleComplete -ModuleExitStatus 'Error'}
     Default    {VMR_ProcessingModuleComplete -ModuleExitStatus 'Null'
                 Write-Host "The script module was unable to trap exit code for $VMRScriptFile."}}
#<<< End of script work >>>
