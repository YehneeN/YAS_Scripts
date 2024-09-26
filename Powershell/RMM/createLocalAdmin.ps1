# Variables
$nomUtilisateur = "{[Nom]}"
$motDePasse = "{[Pass]}"

# Convertir le mot de passe en SecureString
$securePassword = ConvertTo-SecureString $motDePasse -AsPlainText -Force

# Créer le compte utilisateur
try {
    New-LocalUser -Name $nomUtilisateur -Password $securePassword -FullName "Nouvel Utilisateur" -Description "Compte créé par script PowerShell"
    Write-Host "Le compte utilisateur '$nomUtilisateur' a été créé avec succès."
} catch {
    Write-Host "Erreur lors de la création du compte : $_"
    return
}
