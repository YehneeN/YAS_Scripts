############################################
#         YehneeN 2024 - INTECH IT         #
# Script autoHeal 4 check7-Zip.ps1         #
############################################

# Vérifie si 7-Zip est installé et obtient la version
$7zipPath = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*", "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*" | Where-Object { $_.DisplayName -like "*7-Zip*" }

if ($7zipPath) {
    $currentVersion = $7zipPath.DisplayVersion
    Write-Output "7-Zip est installé. Version actuelle: $currentVersion"

    if ($currentVersion -ne "24.08") {
        Write-Output "Version différente de 24.08. Désinstallation de 7-Zip..."
        Start-Process -FilePath $7zipPath.UninstallString -ArgumentList '/S' -Wait
        Start-Sleep -Seconds 60

        Write-Output "Téléchargement et installation de la dernière version de 7-Zip..."
        $installerPath = "$env:Temp\7zip.exe"
        Invoke-WebRequest -Uri "https://7-zip.org/a/7z2408-x64.exe" -OutFile $installerPath
        Start-Process -FilePath $installerPath -ArgumentList '/S' -Wait
        Write-Output "Installation terminée."
    } else {
        Write-Output "La version de 7-Zip est déjà 24.08."
    }
} else {
    Write-Output "7-Zip n'est pas installé."
}