# This script is run at login. It is tied to an event in the task scheduler.
# 

$vcu_computers = @('EGR-JL-RAK1-SRV','EGR-JL-DSK0-SRV')

if ($env:COMPUTERNAME -in $vcu_computers) {
    ~\.mysetup\SetMyDefaultPrinter.ps1
}

~\.mysetup\FreshenWallpaper.ps1

## read-host "pausing ..."
