# Vérification du module
if (-not (Get-Module -ListAvailable -Name Bitlocker)) {
    Write-Host "Le module Bitlocker n'est pas disponible pour cet appareil."
    exit
}

# Check l'état Bitlocker sur C:
$bitlockerStatus = Get-BitLockerVolume -MountPoint "C:"

if ($bitlockerStatus.ProtectionStatus -eq "On") {
    Write-Host "Le disque C: est chiffré par Bitlocker."
} else {
    Write-Host "Le disque C: n'est pas chiffré par Bitlocker."
}