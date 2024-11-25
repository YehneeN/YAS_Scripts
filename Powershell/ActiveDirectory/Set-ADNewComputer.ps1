############################################
#         YehneeN 2024 - INTECH IT         #
############################################

# Variables
    # Ordinateur, Domaine, dossier et fichier
$computerName = "{[NomDeLordinateur]}"
$domainName = "{[NomDuDomaine]}"
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

# Création du compte ordinateur et sauvegarde du fichier texte en local.
djoin.exe /provision /domain $domainName /machine $computerName /savefile $saveFilePath

# Transfert du blob sur le serveur WebDAV
if (Test-Path -Path $saveFilePath) {
    $webClient = New-Object System.Net.WebClient
    $webClient.Credentials = New-Object System.Net.NetworkCredential($username,$password)
    $webClient.UploadFile("$webDavUrl/$($computerName).txt", $saveFilePath)
} else {
    Write-Host "Une erreur a eu lieu et le fichier blob n'a pas été généré. Transfert annulé.."
}
