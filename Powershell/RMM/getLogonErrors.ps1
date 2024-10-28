# Définir une plage de dates pour limiter les événements récupérés
$StartDate = (Get-Date).AddDays(-7)  # Par exemple, récupérer les événements des 7 derniers jours
$EndDate = Get-Date

# Récupérer les événements 4625 du journal de sécurité dans la plage de dates spécifiée
$EventLogs = Get-WinEvent -FilterHashtable @{LogName='Security'; Id=4625; StartTime=$StartDate; EndTime=$EndDate}

# Vérifier si des événements ont été récupérés
if ($EventLogs.Count -eq 0) {
    Write-Output "Aucun événement 4625 trouvé dans la plage de dates spécifiée."
} else {
    Write-Output "$($EventLogs.Count) événements 4625 trouvés."
}

# Parcourir chaque événement et extraire les informations nécessaires
foreach ($event in $EventLogs) {
    $xml = [xml]$event.ToXml()

    # Extraire les informations nécessaires
    $AccountName = $xml.Event.EventData.Data | Where-Object { $_.Name -eq 'TargetUserName' } | Select-Object -ExpandProperty '#text'
    $DomainName = $xml.Event.EventData.Data | Where-Object { $_.Name -eq 'TargetDomainName' } | Select-Object -ExpandProperty '#text'
    $IpAddress = $xml.Event.EventData.Data | Where-Object { $_.Name -eq 'IpAddress' } | Select-Object -ExpandProperty '#text'
    $WorkstationName = $xml.Event.EventData.Data | Where-Object { $_.Name -eq 'WorkstationName' } | Select-Object -ExpandProperty '#text'
    $LogonProcessName = $xml.Event.EventData.Data | Where-Object { $_.Name -eq 'LogonProcessName' } | Select-Object -ExpandProperty '#text'
    $TimeCreated = $event.TimeCreated

    # Afficher les informations extraites si elles existent
    if ($AccountName -and $DomainName -and $IpAddress -and $WorkstationName -and $LogonProcessName) {
        [PSCustomObject]@{
            TimeCreated = $TimeCreated
            AccountName = $AccountName
            DomainName = $DomainName
            IpAddress = $IpAddress
            WorkstationName = $WorkstationName
            LogonProcessName = $LogonProcessName
        }
    } else {
        Write-Output "Impossible d'extraire les informations de l'événement ID $($event.Id) à $($event.TimeCreated)."
    }
}
