########################################################################################
### 0.1
###
### WIP : Script à rendre interactif pour traitement ACL sur multiples 
###         dossiers\sous-dossiers // Ajout, Suppr. Groupe AD ou Utilisateur 
###                                 // Ajout, Suppr. Read,Write,Execute 
###
###     Définir les fonctions \ Perm \ User ou Group 
###
###
### YehneeN - 2024
########################################################################################

$rootFolderPath = ""
$group = ""
$folders = Get-ChildItem -Path $rootFolderPath -Directory

foreach ($folder in $folders) {
    # Ajouter l'interdiction de toutes les autorisations pour le groupe
    $acl = Get-Acl -Path $folder.FullName
    $denyRule = New-Object System.Security.AccessControl.FileSystemAccessRule($group, "FullControl", "Deny")
    $acl.AddAccessRule($denyRule)
    Set-Acl -Path $folder.FullName -AclObject $acl

    # Afficher le nom du dossier traité
    Write-Output "Permissions mises à jour pour le dossier : $($folder.FullName)"
}

Write-Output "Permissions mises à jour pour tous les dossiers principaux."

 