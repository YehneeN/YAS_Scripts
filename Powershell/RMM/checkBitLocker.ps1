##############################################################################################################
# MONITORING PROFIL : Set an alert when eventID 11004 appear.
#
# YehneeN - 2024
##############################################################################################################

# Var
$LogSource = "Atera Monitoring Events"

# Vérification du module
if (-not (Get-Module -ListAvailable -Name Bitlocker)) {
    New-EventLog -LogName "Application" -Source $LogSource -ErrorAction SilentlyContinue
    Write-EventLog -LogName "Application" -Source $LogSource -EventID 11002 -EntryType Error -Message "Module bitlocker disabled or inexistant on this device."
    exit
}

# Check l'état Bitlocker sur C: et remplis les logs.
$bitlockerStatus = Get-BitLockerVolume -MountPoint $env:SystemDrive

if ($bitlockerStatus.ProtectionStatus -eq "On") {
    New-EventLog -LogName "Application" -Source $LogSource -ErrorAction SilentlyContinue
    Write-EventLog -LogName "Application" -Source $LogSource -EventID 11003 -EntryType Information -Message "System disk is currently protected by Bitlocker."
} else {
    # Verification état chiffrement et relance protection si OK
    if ($bitlockerStatus.EncryptionPercentage -eq 100 -and $bitlockerStatus.KeyProtector.RecoveryPassword -ne $null -and $bitlockerStatus.KeyProtector.RecoveryPassword -ne "") {
        Resume-Bitlocker -MountPoint $env:SystemDrive
        Write-EventLog -LogName "Application" -Source $LogSource -EventID 11003 -EntryType Information -Message "Bitlocker has been resumed on the system disk."
        exit
    }

    New-EventLog -LogName "Application" -Source $LogSource -ErrorAction SilentlyContinue
    Write-EventLog -LogName "Application" -Source $LogSource -EventID 11004 -EntryType Error -Message "System disk is not currently protected by Bitlocker."

}