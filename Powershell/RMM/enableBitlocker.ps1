##############################################################################################################
#                   YehneeN - 2024
##############################################################################################################

# Var
$LogSource = "Atera Events"

# Vérification du module
if (-not (Get-Module -ListAvailable -Name Bitlocker)) {
    New-EventLog -LogName "Application" -Source $LogSource -ErrorAction SilentlyContinue
    Write-EventLog -LogName "Application" -Source $LogSource -EventID 11002 -EntryType Error -Message "Module bitlocker disabled or inexistant on this device."
    exit
}

# Activation Bitlocker en utilisant le TPM + clé 
Enable-Bitlocker -MountPoint $env:SystemDrive -TpmProtector -SkipHardwareTest
Add-BitLockerKeyProtector -MountPoint $env:SystemDrive -RecoveryPasswordProtector

New-EventLog -LogName "Application" -Source $LogSource -ErrorAction SilentlyContinue
Write-EventLog -LogName "Application" -Source $LogSource -EventID 11005 -EntryType Information -Message "Bitlocker has been enabled on the system drive."