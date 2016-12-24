<#
.SYNOPSIS
    Logon script triggered by Active Setup to mapped simulated network drives.

    The drives are mapped via Active Setup as a one time run for each user, a hidden network share
    was created as part of the build in location C:\Windows\debug\SimulatedNetworkDrives. This
    location was used due to the fact that it is an App-V exclusion, thus wont be captured as part
    of a sequence. Common drives are prefixed with 'Common' and user home drives are prefixed with
    the user name.
 
.LINK
Author:.......http://www.linkedin.com/in/rileylim
#>



# Start of script work ############################################################################
$HomeDrives = '<<HomeDrivesMask>>'
$CommonDrives = '<<CommonDrivesMask>>'

#Debug parameters, the share must exist before debugging
#$HomeDrives = 'H:Home'
#$CommonDrives = 'I:IT Dept,S:Shared'

#Text to be added to the simulated network drive
$SimulatedNetworkFolderReadMe += "This is a simulated network drive that can be found in this location `"C:\Windows\debug\SimulatedNetworkDrives`" `r`n"
$SimulatedNetworkFolderReadMe += 'This is an exclusion area for App-V Sequencer, thus no file will be captured.'

#Creating folders and shares.
$HomeDrivesArray = $HomeDrives.Split(',')
$HomeDrivesArray | ForEach-Object {Write-Debug "Working on object $_"
                                   $DriveToMap = $_.Split(':')
                                   If (!(Test-Path ($($DriveToMap[0] + ':'))))
                                           {$CreateUNCFolder = 'User ' + "$Env:USERNAME " + $DriveToMap[0] + ' ' + $DriveToMap[1]
                                            If (!(Test-Path "\\LocalHost\SimulatedNetworkDrives$\$CreateUNCFolder"))
                                                    {New-Item -ItemType Directory -Path "\\LocalHost\SimulatedNetworkDrives$\$CreateUNCFolder"
                                                     $SimulatedNetworkFolderReadMe | Out-File "\\LocalHost\SimulatedNetworkDrives$\$CreateUNCFolder\This is a simulated network drive.txt"}
                                            & Net Use $($DriveToMap[0] + ':') "\\LocalHost\SimulatedNetworkDrives$\$CreateUNCFolder" /Persistent:Yes
                                            Write-Debug 'Renaming the drive label'
                                            $Shell = New-Object -ComObject Shell.Application
                                            $Shell.NameSpace("$($DriveToMap[0] + ':')").Self.Name = "$($DriveToMap[1])"}}
                                   
$CommonDrivesArray = $CommonDrives.Split(',')
$CommonDrivesArray | ForEach-Object {Write-Debug "Working on object $_"
                                     $DriveToMap = $_.Split(':')
                                     If (!(Test-Path ($($DriveToMap[0] + ':'))))
                                             {$CreateUNCFolder = 'Common ' + $DriveToMap[0] + ' ' + $DriveToMap[1]
                                              If (!(Test-Path "\\LocalHost\SimulatedNetworkDrives$\$CreateUNCFolder"))
                                                      {New-Item -ItemType Directory -Path "\\LocalHost\SimulatedNetworkDrives$\$CreateUNCFolder"}
                                              & Net Use $($DriveToMap[0] + ':') "\\LocalHost\SimulatedNetworkDrives$\$CreateUNCFolder" /Persistent:Yes
                                              Write-Debug 'Renaming the drive label'
                                              $Shell = New-Object -ComObject Shell.Application
                                              $Shell.NameSpace("$($DriveToMap[0] + ':')").Self.Name = "$($DriveToMap[1])"}}
#<<< End of script work >>>
