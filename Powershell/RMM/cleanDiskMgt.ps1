############################################
#         YehneeN 2024 - INTECH IT         #
############################################

# Fonction pour vérifier si un programme est installé
function Test-ProgramInstalled {
    param (
        [string]$programPath
    )
    return Test-Path $programPath
}

# Vérifier l'espace disque avant et après le nettoyage
$beforeCleanup = Get-PSDrive -Name C
$rdBeforeCleanup = [math]::Round($beforeCleanup.Free / 1GB, 1)
Write-Output "Espace disque avant nettoyage : $rdBeforeCleanup"

# Supprimer les fichiers temporaires pour chaque utilisateur
Write-Output "Suppression des fichiers temporaires..."
Get-ChildItem -Directory "C:\Users" | ForEach-Object {
    $userTempPath = "$($_.FullName)\AppData\Local\Temp"
    Write-Output "Suppression des fichiers temporaires pour l'utilisateur $($_.Name)..."
    Remove-Item "$userTempPath\*" -Force -Recurse -ErrorAction SilentlyContinue
}

# Vider la corbeille globale
Write-Output "Vider la corbeille globale..."
Remove-Item "$env:SystemDrive\$Recycle.Bin\*" -Force -Recurse -ErrorAction SilentlyContinue

# Supprimer les fichiers temporaires du système
Write-Output "Suppression des fichiers temporaires du système..."
Remove-Item "$env:SystemRoot\Temp\*" -Force -Recurse -ErrorAction SilentlyContinue

# Supprimer les fichiers de mises à jour temporaires
Write-Output "Suppression des fichiers de mises à jour temporaires..."
Remove-Item "$env:SystemRoot\SoftwareDistribution\Download\*" -Force -Recurse -ErrorAction SilentlyContinue

# Nettoyer les journaux d'événements
Write-Output "Nettoyage des journaux d'événements..."
wevtutil el | ForEach-Object { wevtutil cl $_ } -ErrorAction SilentlyContinue

# Effectuer le nettoyage
$afterCleanup = Get-PSDrive -Name C
$rdAfterCleanup = [math]::Round($afterCleanup.Free / 1GB, 1)
Write-Output "Espace disque libre après nettoyage : $rdAfterCleanup"

Write-Output "Opérations terminées."
