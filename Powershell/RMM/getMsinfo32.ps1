############################################
#         YehneeN 2024 - INTECH IT         #
############################################

# Variables
    # Info ordi
$ComputerName = "VAR STAT, DYN, Autre...."
$LocalBackupDirectory = "C:\"
$msinfoFileName = "$ComputerName.nfo"
$msinfoFilePath = Join-Path -Path $LocalBackupDirectory -ChildPath $msinfoFileName

    # WebDAV ; authentification et lien
$webDavUrl = ""
$username = ""
$password = ""

# Exécuter msinfo32 et attendre qu'il se termine
Start-Process -FilePath "msinfo32.exe" -ArgumentList "/nfo $msinfoFilePath" -Wait

# Transfert du fichier sur le serveur WebDAV avec Invoke-WebRequest
if (Test-Path -Path $msinfoFilePath) {
    try {
        $webDavUrlWithFile = "$webDavUrl/$msinfoFileName"
        $credentials = New-Object System.Management.Automation.PSCredential ($username, (ConvertTo-SecureString $password -AsPlainText -Force))
        
        Invoke-WebRequest -Uri $webDavUrlWithFile -Method Put -InFile $msinfoFilePath -Credential $credentials -UseBasicParsing
        Write-Host "Fichier téléchargé avec succès."
    } catch {
        Write-Host "Erreur lors du téléchargement du fichier : $_"
    }
} else {
    Write-Host "Une erreur a eu lieu ; le fichier n'existe pas. Transfert annulé."
}
