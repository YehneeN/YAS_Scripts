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

# Vérification du dossier C:\ADBlobs
if (-Not (Test-Path -Path $dirPath)) {
    New-Item -ItemType Directory -Path $dirPath
}

# Transfert du blob depuis le serveur WebDAV
$webClient = New-Object System.Net.WebClient
$webClient.Credentials = New-Object System.Net.NetworkCredential($username,$password)
$webClient.DownloadFile("$webDavUrl/$($computerName).txt", $saveFilePath)

# Vérification du transfert
if (Test-Path -Path $saveFilePath) {
    # Appliquer le fichier d'adhésion
    djoin.exe /requestodj /loadfile $saveFilePath /windowspath %SystemRoot% /localos
    shutdown.exe -t 0 -r -f
} else {
    Write-Host "Fichier blob introuvable."
}
