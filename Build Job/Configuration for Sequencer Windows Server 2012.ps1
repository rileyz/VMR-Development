﻿# Shared Sequencer Configuration Windows Server 2012 Build ########################################
#Setting Wallpaper for Administrator.
Write-Output 'Setting Wallpaper for Administrator.'
VMR_RunModule -Module Framework\Module_DesktopExperience-SetWallPaper.ps1 -Arguments "-Wallpaper 'Sequencer.jpg' -PicturePosition 'Center' -DesktopColour '229 115 0'"

#Configure Windows Services.
Write-Output 'Configure Windows Services: SequencerConfiguration_WindowsServer2012.csv'
VMR_RunModule -Module Framework\Module_Windows-Services-GlobalConfigure.ps1 -Arguments '-WindowsServicesCSV SequencerConfiguration_WindowsServer2012.csv'
#<<< End Shared Sequencer Configuration Windows Server 2012 Build >>>
