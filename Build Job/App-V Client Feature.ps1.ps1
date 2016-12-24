# Start Application Virtualization Client As A Feature Build ######################################
Write-Output 'Installing Feature Application Virtualization Client.'
VMR_RunModule -Module Framework\Module_Software-App-V-Client-Enable-Feature.ps1

Write-Output 'Installing Application Virtualization 5.0 Client UI for SP2 and greater'
VMR_RunModule -Module Framework\Module_Software-App-V-ClientUIApplication.ps1

Write-Output 'Installing Application Virtualization Client Custom Configuration.'
VMR_RunModule -Module Framework\Module_Software-App-V-ClientConfiguration.ps1
#<<< End of Application Virtualization Client As A Feature Build >>>
