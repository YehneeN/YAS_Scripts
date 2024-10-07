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


# Définir le chemin de base de l'arborescence
$basePath = "D:\TEST-SCRIPT"

# Définir le groupe AD et les permissions
$adGroup = "Domaine\Groupe"
$permissions = [System.Security.AccessControl.FileSystemRights]"Read, Write, ExecuteFile"

# Fonction pour ajouter les permissions
function Add-Permissions {
    param (
        [string]$folderPath,
        [string]$group,
        [string]$perms
    )
    $acl = Get-Acl $folderPath
    $accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($group, $perms, "ContainerInherit,ObjectInherit", "None", "Allow")
    $acl.SetAccessRule($accessRule)
    Set-Acl $folderPath $acl
    Write-Output "Modification des ACL sur le dossier $folderPath"
}

# Parcourir les dossiers et sous-dossiers
Get-ChildItem -Path $basePath -Recurse -Directory | ForEach-Object {
    if (Test-Path "$($_.FullName)\02_Rendus") {
        Add-Permissions -folderPath "$($_.FullName)\02_Rendus" -group $adGroup -perms $permissions
    }
}