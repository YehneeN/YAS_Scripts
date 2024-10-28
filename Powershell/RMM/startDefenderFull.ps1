#################################################################
#
#   MONITORING PROFIL : Set an alet when evenID 11006 appear.
#
#   YehneeN -2024
#################################################################

# VAR
$LogSource = "Atera Monitoring Events"
$eID = "11006"
$logDir = "C:\scanATP"
$logPath = "$logDir\LogFile.txt"

# Try & Create logDir
if (!(Test-Path -Path $logDir)) {
    New-Item -ItemType Directory -Path $logDir
}

# Démarrer un scan complet
Start-MpScan -ScanType FullScan

# Attendre la fin du scan
$scanStatus = $null
do {
    Start-Sleep -Seconds 10
    $scanStatus = Get-MpComputerStatus | Select-Object -ExpandProperty AntivirusEnabled
} while ($scanStatus)

# Récupérer le rapport de scan
$scanReport = Get-MpThreatDetection
# Journaliser les résultats dans un fichier
$scanReport | Out-File -FilePath $logPath
# Log Event
New-EventLog -LogName "Application" -Source $LogSource -EventID $eID -EntryType Information -Message "Le scan est terminé. Verifiez les logs."
