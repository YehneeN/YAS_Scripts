##############################################################################################################
#
# YehneeN - 2024
##############################################################################################################

# Var
$LogSource = "Atera Events"

# Vérification du module
if (-not (Get-Module -ListAvailable -Name Bitlocker)) {
    New-EventLog -LogName "Application" -Source $LogSource -ErrorAction SilentlyContinue
    Write-EventLog -LogName "Application" -Source $LogSource -EventID 11002 -EntryType Error -Message "Module bitlocker disabled or inexistant on this device."
    exit
}

# Chemin du répertoire partagé pour sauvegarder la RecoveryKey
#$netPath = {[sharedFolder]}

# Activation Bitlocker en utilisant le TPM + sauvegarde de la clé 
Enable-Bitlocker -MountPoint $env:SystemDrive -TpmProtector -SkipHardwareTest #-RecoveryKeyPath $netPath 
New-EventLog -LogName "Application" -Source $LogSource -ErrorAction SilentlyContinue
Write-EventLog -LogName "Application" -Source $LogSource -EventID 11005 -EntryType Information -Message "Bitlocker has been enabled on the system drive."