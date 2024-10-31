#################################################################
#
#   Désactivation du protocole SMB v1.0 
#       sans forcer le redémarrage de l'ordinateur
#       Pop-Up service IT pour inviter l'utilisateur à redémarrer
#
#   YehneeN - 2024
#################################################################

# Var
$LogSource = "Atera Monitoring Events"

# Vérification SMB v1.0
$SMB1Status = Get-WindowsOptionalFeature -Online -FeatureName "SMB1Protocol"

if ($SMB1Status.State -eq "Enabled") {
    New-EventLog -LogName "Application" -Source $LogSource -ErrorAction SilentlyContinue
    Write-EventLog -LogName "Application" -Source $LogSource -EventID 11011 -EntryType Warning -Message "Attention - SMB v1.0 est activé sur cet ordinateur."
    Write-EventLog -LogName "Application" -Source $LogSource -EventID 11012 -EntryType Information -Message "SMB v1.0 va être désactivé."
    
    # Désactivation SMB v1.0
    $resultDisable = Disable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol -NoRestart -ErrorAction SilentlyContinue
    if ($resultDisable.RestartNeeded -eq $true) {
        $users = quser | ForEach-Object {
            $line = $_.ToString().Split(">", [System.StringSplitOptions]::RemoveEmptyEntries)[-1].Trim() 
            if ($line -match "^\s*(\S+)\s+(\S+)\s+\d+\s+actif") {
                $matches[1]
            }
        }
        foreach ($user in $users) {
            if ($user -ne "") {
                msg.exe $user "Le protocole SMB v1.0, obsolète, a été désactivé sur votre ordinateur.
        
        Afin de valider la suppression de cette fonctionnalité veuillez redémarrer votre ordinateur pour appliquer les modifications.
        
        INTECH - Service IT"
            }
        }
        exit 0
    } 
} else {
    New-EventLog -LogName "Application" -Source $LogSource -ErrorAction SilentlyContinue
    Write-EventLog -LogName "Application" -Source $LogSource -EventID 11012 -EntryType Information -Message "SMB v1.0 est déjà désactivé. Aucune action nécessaire."
    Write-Output "SMB v1.0 est déjà désactivé. Aucune action nécessaire."
    exit 0
}