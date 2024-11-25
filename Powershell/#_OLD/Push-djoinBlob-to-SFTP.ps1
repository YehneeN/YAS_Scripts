# Spécifiez le nom d'ordinateur à provisionner
$ComputerName = "{[NomDeLordinateur]}"

# Spécifiez le nom du domaine et le nom de l'OU (Unité d'Organisation) si nécessaire
$DomainName = "{[NomDuDomaine]}"

# Spécifiez le chemin du répertoire où vous souhaitez sauvegarder le fichier localement
$LocalBackupDirectory = "C:\WinSCP_DLL"

# Spécifiez les informations de connexion au serveur SFTP distant
$SftpServer = ""
$SftpUsername = ""
$SftpPassword = "{[PasswordSFTP]}" # VARIABLE : Password
$SftpPort = "2222"
$SshHostKeyFingerprint = "ssh-ed25519 255 Q0v0awoHQ6CfwW0Eep+LZl9MdaDwgXN/qwP0oLubv0I;ssh-ed25519 255 dc:5a:8d:52:0b:2d:51:36:2b:e3:17:17:9a:ea:37:34"

# Générez le nom de fichier pour le blob de provisionnement
$BlobFileName = $ComputerName
$BlobFilePath = Join-Path -Path $LocalBackupDirectory -ChildPath $BlobFileName

# Exécute la commande djoin pour provisionner le compte d'ordinateur
	$WinSCPLibFile = "C:\WinSCP_DLL\WinSCPnet.dll"
	if (Test-Path -Path $WinSCPLibFile -PathType Leaf){
djoin.exe /provision /domain $DomainName /machine $ComputerName /savefile $BlobFilePath
	} else {
		Write-Host "Vous devez installer la library WinSCP --> Script : Download_WinSCP_DLL.ps1"
	}

# Vérifie si la commande djoin s'est exécutée avec succès
if ($? -eq $true) {
    Write-Host "Provisionnement de l'ordinateur $ComputerName réussi."

    # Importez la bibliothèque WinSCP
    Add-Type -Path "C:\WinSCP_DLL\WinSCPnet.dll"

    try {
        # Créez une session SFTP avec les informations de connexion
        $sessionOptions = New-Object WinSCP.SessionOptions
        $sessionOptions.Protocol = [WinSCP.Protocol]::Sftp
        $sessionOptions.HostName = $SftpServer
        $sessionOptions.UserName = $SftpUsername
        $sessionOptions.Password = $SftpPassword
		$sessionOptions.PortNumber = $SftpPort
		$sessionOptions.SshHostKeyFingerprint = $SshHostKeyFingerprint

        $session = New-Object WinSCP.Session

        # Ouvrez la session SFTP
        $session.Open($sessionOptions)

        # Transférez le fichier vers le serveur SFTP distant
        $transferResult = $session.PutFiles($BlobFilePath, "/AteraFiles/")

        # Vérifiez si le transfert s'est effectué avec succès
        if ($transferResult.IsSuccess) {
            Write-Host "Transfert du fichier vers le serveur SFTP réussi."
        } else {
            Write-Host "Le transfert du fichier vers le serveur SFTP a échoué."
        }
    } finally {
        # Fermez la session SFTP
        $session.Dispose()
    }
} else {
    Write-Host "Provisionnement de l'ordinateur $ComputerName a échoué."
}
