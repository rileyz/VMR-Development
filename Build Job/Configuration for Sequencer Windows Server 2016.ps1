﻿# Shared Sequencer Configuration Windows Server 2016 Build ########################################
#Setting Wallpaper for Administrator.
Write-Output 'Setting Wallpaper for Administrator.'
VMR_RunModule -Module Framework\Module_DesktopExperience-SetWallPaper.ps1 -Arguments "-Wallpaper 'Sequencer.jpg' -PicturePosition 'Center' -DesktopColour '229 115 0'"

#Configure Windows Services.
Write-Output 'Configure Windows Services: SequencerConfiguration_WindowsServer2016.csv'
VMR_RunModule -Module Framework\Module_Windows-Services-GlobalConfigure.ps1 -Arguments '-WindowsServicesCSV SequencerConfiguration_WindowsServer2016.csv'

#Disable Windows Defender.
Write-Output 'Disable Windows Defender.'
VMR_RunModule -Module Framework\Module_Windows-WindowsDefender-GlobalDisable.ps1
#<<< End of Shared Sequencer Configuration Windows Server 2016 Build >>>
