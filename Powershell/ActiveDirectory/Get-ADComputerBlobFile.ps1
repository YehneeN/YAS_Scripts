############################################
#         YehneeN 2024 - INTECH IT         #
############################################

# Variables
    # Ordinateur, Domaine, dossier et fichier
$computerName = "{[NomDeLordinateur]}"
$dirPath = "C:\ADBlobs"
$saveFilePath = "C:\ADBlobs\$computerName.txt"

    # WebDAV ; authentification et lien
$webDavUrl = ""
$username = ""
$password = ""
$webDavUrlWithFile = "$webDavUrl/$computerName.txt"

# Vérification du dossier C:\ADBlobs
if (-Not (Test-Path -Path $dirPath)) {
    New-Item -ItemType Directory -Path $dirPath
}

# Transfert du blob sur le serveur WebDAV avec Invoke-WebRequest
$credentials = New-Object System.Management.Automation.PSCredential ($username, (ConvertTo-SecureString $password -AsPlainText -Force))
Invoke-WebRequest -Uri $webDavUrlWithFile -OutFile $saveFilePath -Credential $credentials -UseBasicParsing
Write-Host "Fichier téléchargé avec succès."


if (Test-Path -Path $saveFilePath) {
    djoin.exe /requestodj /loadfile $saveFilePath /windowspath %SystemRoot% /localos
    shutdown.exe -t 0 -r -f
} else {
    Write-Host "Une erreur a eu lieu et le fichier blob n'a pas été généré. Transfert annulé."
}
