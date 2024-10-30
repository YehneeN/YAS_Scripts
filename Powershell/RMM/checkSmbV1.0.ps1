#################################################################
#
#   Edit du script de Pyrithe 
#       Monitoring version SMB
#       Set an alert for ID 10011 (warn) / 10013 (opt - info)
#           or threshold monitoring script number eq to 1 (warn) 3 (info)
#
#   YehneeN - 2024
#################################################################

$LogSource = "Atera Monitoring Events"
$smbID1 = "10011"
$smbID2 = "10012"
$smbID3 = "10013"

# Check SMB v1.0 status
$SMB1Status = Get-WindowsOptionalFeature -Online -FeatureName "SMB1Protocol"

# Result from status
if ($SMB1Status.State -eq "Enabled") {
    # SMB v1.0 is enable - create ID 10011
    New-EventLog -LogName "Application" -Source $LogSource -ErrorAction SilentlyContinue
    Write-EventLog -LogName "Application" -Source $LogSource -EventID $smbID1 -EntryType Warning -Message "Attention - SMB v1.0 est activé sur cet ordinateur."
    Write-Output "1"
} elseif ($SMB1Status.State -eq "Disabled") {
    # SMB v1.0 is disabled - create ID 10012
    New-EventLog -LogName "Application" -Source $LogSource -ErrorAction SilentlyContinue
    Write-EventLog -LogName "Application" -Source $LogSource -EventID $smbID2 -EntryType Information -Message "SMB v1.0 n'est pas activé sur cet ordinateur."
    Write-Output "2"
} else {
    # Error when check the status of SMB v1.0 protocol - create ID 10013
    New-EventLog -LogName "Application" -Source $LogSource -ErrorAction SilentlyContinue
    Write-EventLog -LogName "Application" -Source $LogSource -EventID $smbID3 -EntryType Information -Message "Impossible de vérifier si SMB v1.0 est activé."
    Write-Output "3"
}