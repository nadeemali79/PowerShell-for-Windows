# Recover BitLocker Key
$Resume = get-bitlockervolume | Resume-Bitlocker
((get-bitlockervolume).KeyProtector | Where-Object -property keyprotectortype -eq RecoveryPassword |   select-object -last 1).recoverypassword        
