#Enable bitlocker withTPM and prints the new recovery key to the console.
reagentc /enable
$EnableBitlocker = Enable-Bitlocker -MountPoint $($ENV:SystemDrive) -UsedSpaceOnly -RecoveryPasswordProtector
