##############################################################################################################
# MONITORING PROFIL : Set an alert when eventID 11004 appear.
#
# YehneeN - 2024
##############################################################################################################

# Var
$LogSource = "Atera Monitoring Events"

# Vérification du module
if (-not (Get-Module -ListAvailable -Name Bitlocker)) {
    New-EventLog -LogName "Application" -Source $LogSource -ErrorActionSilentlyContinue
    Write-EventLog -LogName "Application" -Source $LogSource -EventID 11002 -EntryType Error "Module bitlocker disabled or inexistant on this device."
    exit
}

# Check l'état Bitlocker sur C: et remplis les logs.
$bitlockerStatus = Get-BitLockerVolume -MountPoint "C:"

if ($bitlockerStatus.ProtectionStatus -eq "On") {
    New-EventLog -LogName "Application" -Source $LogSource -ErrorActionSilentlyContinue
    Write-EventLog -LogName "Application" -Source $LogSource -EventID 11003 -EntryType Error "System disk is currently protected by Bitlocker."
} else {
    New-EventLog -LogName "Application" -Source $LogSource -ErrorActionSilentlyContinue
    Write-EventLog -LogName "Application" -Source $LogSource -EventID 11004 -EntryType Error "System disk is not currently protected by Bitlocker."
}