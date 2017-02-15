﻿# Start Application Virtualization 5.1 Client with Hotfix 5 Build #################################
Write-Output 'Installing Application Virtualization 5.1 Client.'
VMR_RunModule -Module Framework\Module_Software-App-V-Client5.1.ps1

Write-Output 'Installing Application Virtualization 5.1, Hotfix 5.'
VMR_RunModule -Module Framework\Module_Software-App-V-Client5.1HF5.ps1

Write-Output 'Installing Application Virtualization 5.0 Client UI for SP2 and greater'
VMR_RunModule -Module Framework\Module_Software-App-V-ClientUIApplication.ps1

Write-Output 'Installing Application Virtualization Client Custom Configuration.'
VMR_RunModule -Module Framework\Module_Software-App-V-ClientConfiguration.ps1
#<<< End of Application Virtualization 5.1 Client with Hotfix 5 Build >>>