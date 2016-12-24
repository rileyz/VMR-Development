# Start Application Virtualization Sequencer As A Feature Build ###################################
Write-Output 'Installing Feature Application Virtualization Sequencer.'
VMR_RunModule -Module Framework\Module_Software-App-V-Sequencer-Install-Feature.ps1

Write-Output 'Creating Application Virtualization Sequencer shortcut with PVAD switch.'
VMR_RunModule -Module Framework\Module_Software-App-V-SequencerPVADShortcut.ps1

Write-Output 'Installing Application Virtualization Sequencer Custom Configuration.'
VMR_RunModule -Module Framework\Module_Software-App-V-SequencerConfiguration.ps1
#<<< End of Application Virtualization Sequencer As A Feature Build >>>
