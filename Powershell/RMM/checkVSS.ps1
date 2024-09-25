#######################################################################################
# MONITORING Profil : Set an alert when the returned value is different than "Healthy"
# Define the value of snapshot minimum number in the first variable
#
# SPIP Informatique - 2023
# EDIT : YehneeN - 2024
#######################################################################################


$LogSource = "Atera Monitoring Events"
$SnapshotCountMin = 2
$Snapshots = Get-CimInstance -ClassName Win32_ShadowCopy -Property *

if (!$SnapShots -or $SnapshotCountMin -gt $Snapshots.length ) {
	write-host "Unhealthy - No snapshot, or not enought regarding your politic."
	write-host There are only $Snapshots.length snapshot, you should take a look.
	New-EventLog -LogName "Application" -Source $LogSource -ErrorAction SilentlyContinue
	Write-EventLog -LogName "Application" -Source $LogSource -EventID 11001 -EntryType Error -Message "Not enought restore points exist" 
	exit 1
} else {
	write-host "Healthy"
	write-host $Snapshots.length restore points available.
}

Get-ComputerRestorePoint

