############################################
#         YehneeN 2024 - INTECH IT         #
############################################

# Vérifie si 7-Zip est installé et obtient la version
$7zipPath = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*", "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*" | Where-Object { $_.DisplayName -like "*7-Zip*" }

if ($7zipPath) {
    $currentVersion = $7zipPath.DisplayVersion
    Write-Output "7-Zip est installé. Version actuelle: $currentVersion"

    if ($currentVersion -ne "24.09") {
        Write-Output "7-zip non-conforme - Dernière version = 24.09"
    } else {
        Write-Output "La version de 7-Zip est conforme."
    }
} else {
    Write-Output "7-Zip n'est pas installé."
}