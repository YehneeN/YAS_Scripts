# Chemin du répertoire que vous souhaitez vérifier ou créer
$repertoireDLL = "C:\WinSCP_DLL"

# Vérifiez si le répertoire existe
if (-not (Test-Path -Path $repertoireDLL -PathType Container)) {
    # Le répertoire n'existe pas, donc nous le créons
    New-Item -Path $repertoireDLL -ItemType Directory
    Write-Host "Repertoire cree : $repertoireDLL"
	Write-Host "Vous devez installer la library WinSCP --> Script : Download_WinSCP_DLL.ps1"
} else {
    # Le répertoire existe déjà
    Write-Host "Le repertoire $repertoireDLL existe."

	$WinSCPLibFile = "C:\WinSCP_DLL\WinSCPnet.dll"

	if (Test-Path -Path $WinSCPLibFile -PathType Leaf) {
    Write-Host "Le fichier $WinSCPLibFile existe."
	Write-Host "Le script peut continuer."
	# Spécifiez les informations de connexion SFTP
$SftpServer = "IP/FQDN"
$SftpUsername = ""
$SftpPassword = "{[PasswordSFTP]}" # VARIABLE : Password
$SftpPort = "2222"
$SshHostKeyFingerprint = "ssh-ed25519 255 Q0v0awoHQ6CfwW0Eep+LZl9MdaDwgXN/qwP0oLubv0I;ssh-ed25519 255 dc:5a:8d:52:0b:2d:51:36:2b:e3:17:17:9a:ea:37:34"

# Spécifiez le chemin du répertoire SFTP où se trouve le fichier à télécharger
$SftpRemoteDirectory = "/AteraFiles/"

# Spécifiez le nom du fichier à télécharger // VARIABLE ; Nom Du Poste
$RemoteFileName = "{[NomOrdinateur]}"

# Spécifiez le chemin du répertoire local où vous souhaitez enregistrer le fichier
$LocalDirectory = "C:\WinSCP_DLL"

    # Importez la bibliothèque WinSCP
Add-Type -Path "C:\WinSCP_DLL\WinSCPnet.dll"

# Créez une session SFTP avec les informations de connexion
$sessionOptions = New-Object WinSCP.SessionOptions
$sessionOptions.Protocol = [WinSCP.Protocol]::Sftp
$sessionOptions.HostName = $SftpServer
$sessionOptions.UserName = $SftpUsername
$sessionOptions.Password = $SftpPassword
$sessionOptions.PortNumber = $SftpPort
$sessionOptions.SshHostKeyFingerprint = $SshHostKeyFingerprint

$session = New-Object WinSCP.Session

try {
    # Ouvrez la session SFTP
    $session.Open($sessionOptions)

    # Chemin complet du fichier à télécharger sur le serveur SFTP
    $SftpRemoteFilePath = "$SftpRemoteDirectory/$RemoteFileName"

    # Téléchargez le fichier depuis le serveur SFTP vers le répertoire local
    $LocalFilePath = Join-Path -Path $LocalDirectory -ChildPath $RemoteFileName
    $session.GetFiles($SftpRemoteFilePath, $LocalFilePath).Check()

    Write-Host "Fichier telecharge avec succes depuis le serveur SFTP et enregistre dans : $LocalFilePath"
} finally {
    # Fermez la session SFTP
    $session.Dispose()
}
}

else {
    Write-Host "Le fichier $WinSCPLibFile n'existe pas."
	Write-Host "Vous devez installer la library WinSCP --> Script : Download_WinSCP_DLL.ps1"
}
}

# Exécute la commande djoin pour lier le compte d'ordinateur de domaine
djoin.exe /requestodj /loadfile $LocalFilePath /domain {[Domaine]} /windowspath C:\Windows /localos

shutdown -t 20 -r -f
