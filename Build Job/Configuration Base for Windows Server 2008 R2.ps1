﻿# Start Windows Server 2008 R2 Build ##############################################################
Write-Output 'Adjusting Power Plan to High Performance.'
VMR_RunModule -Module Framework\Module_Windows-PowerModeHighPerformance-GlobalEnable.ps1

Write-Output 'Installing Windows 2008 R2 Service Pack 1 on the virtual machine.'
VMR_RunModule -Module Framework\Module_Windows-WindowsUpdate-KB976932.ps1

Write-Output 'Installing April 2015 Servicing Stack update for Windows 2008 R2 Service Pack 1 on the virtual machine.'
VMR_RunModule -Module Framework\Module_Windows-WindowsUpdate-KB3020369.ps1

Write-Output 'Installing Convenience Rollup update for Windows 2008 R2 Service Pack 1 on the virtual machine.'
VMR_RunModule -Module Framework\Module_Windows-WindowsUpdate-KB3125574.ps1

Write-Output 'Installing Windows Server 2008 R2 updates via WSUSOffline.'
VMR_RunModule -RerunUntilComplete -WaitForWindowsUpdateWorkerProcess -Module Framework\Module_Windows-WindowsUpdate-WSUSOffline.ps1

Write-Output 'Configure Windows Task Schedules: BaseConfiguration_WindowsServer2008R2.'
VMR_RunModule -Module Framework\Module_Windows-TaskScheduler-GlobalConfigure.ps1 -Arguments '-TaskSchedulesCSV BaseConfiguration_WindowsServer2008R2.csv'

Write-Output 'Importing Security Policy: RelaxPasswordPolicy.inf.'
VMR_RunModule -Module Framework\Module_Windows-SecurityPolicy-GlobalConfigure.ps1 -Arguments '-ImportPolicy RelaxPasswordPolicy.inf'

Write-Output 'Importing Security Policy: DisableSecureLogOn.inf.'
VMR_RunModule -Module Framework\Module_Windows-SecurityPolicy-GlobalConfigure.ps1 -Arguments '-ImportPolicy DisableSecureLogOn.inf'

Write-Output 'Disable computer account password change.'
VMR_RunModule -Module Framework\Module_Windows-ComputerAccountPasswordChange-GlobalDisable.ps1

Write-Output 'Disable Shutdown Event Tracking.'
VMR_RunModule -Module Framework\Module_Windows-ShutdownEventTracking-GlobalDisable.ps1

Write-Output 'Enable Remote Desktop Connection.'
VMR_RunModule -Module Framework\Module_DesktopExperience-EnableRemoteDesktopConnection.ps1

Write-Output 'Creating Test User Accounts.'
VMR_RunModule -Module Framework\Module_Windows-UserAccounts-Add.ps1

Write-Output 'Configure to connect simulated mapped network drives on logon.'
VMR_RunModule -Module Framework\Module_Windows-UserAccounts-NetworkDrives.ps1 -Arguments "-HomeDrives `'$MimicHomeDrives`' -CommonDrives `'$MimicCommonDrives`'"

Write-Output 'Enabling auto logon.'
VMR_RunModule -Module Framework\Module_Windows-UserAccounts-AutoLogon.ps1 -Arguments '-AutoLogonUserName Cached'

Write-Output 'Waiting 5 minutes to allow profile first time tasks to complete.'
Start-Sleep -Seconds 300

Write-Output 'Enabling auto logon.'
VMR_RunModule -Module Framework\Module_Windows-UserAccounts-AutoLogon.ps1 -Arguments "-AutoLogonUserName $GuestUserName -AutoLogonPassword $GuestPassword"

Write-Output 'Show hidden file types and extensions.'
VMR_RunModule -Module Framework\Module_DesktopExperience-ShowFileExtsAndHiddenFiles.ps1

Write-Output 'Enabling show all icons and notifications.'
VMR_RunModule -Module Framework\Module_DesktopExperience-ShowAllIconsAndNotifications.ps1

Write-Output 'Disable Server Manager on login.'
VMR_RunModule -Module Framework\Module_DesktopExperience-DisableServerManagerOnLogin.ps1

Write-Output 'Disable Initial Configuration Tasks on login.'
VMR_RunModule -Module Framework\Module_Windows-InitialConfigurationTasksAtLogon-GlobalDisable.ps1

Write-Output 'Disable Internet Explorer first run wizard.'
VMR_RunModule -Module Framework\Module_Windows-InternetExplorerCustomiseOnFirstRun-GlobalDisable.ps1

Write-Output 'Set Internet Explorer to about:blank.'
VMR_RunModule -Module Framework\Module_DesktopExperience-ConfigureInternetExplorerHomePage.ps1

write-Output 'Disable Internet Explorer Enhanced Security Configuration.'
VMR_RunModule -Module Framework\Module_Windows-InternetExplorerEnhancedSecurityConfiguration-GlobalDisable.ps1

Write-Output 'Adding Repackaging Tools.'
VMR_RunModule -Module Custom\Module_Custom-PackagingTools.ps1

Write-Output 'Creating Binaries folder and shortcut.'
VMR_RunModule -Module Custom\Module_Custom-CreateMyBinariesFolder.ps1

Write-Output 'Installing Office Professional Plus.'
VMR_RunModule -Module Framework\Module_Software-OfficeProfessionalPlus.ps1 -Arguments "-Version $OfficeVersion"

Write-Output 'Installing Windows 2008 R2 and Office updates via WSUSOffline.'
VMR_RunModule -RerunUntilComplete -Module Framework\Module_Windows-WindowsUpdate-WSUSOffline.ps1
#<<< End of Windows Server 2008 R2 Build >>>



<#
Virtual Machine Runner  -  Copyright (C) 2016-2017  -  Riley Lim

This program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the 
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without
even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU 
General Public License for more details.

You should have received a copy of the GNU General Public License along with this program.  If not, 
see <http://www.gnu.org/licenses/>.
#>
