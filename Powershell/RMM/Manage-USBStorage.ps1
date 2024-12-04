############################################
#         YehneeN 2024 - INTECH IT         #
############################################

# Fix var
$enable = {[TrueOrFalse]} # $true ou $false à indiquer dans le RMM

if ($enable) {
    # Activer les périphériques de stockage USB
    $regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\USBSTOR"
    Set-ItemProperty -Path $regPath -Name "Start" -Value 3

    # Activer les périphériques de stockage USB déjà installés
    $regPath = "HKLM:\SYSTEM\CurrentControlSet\Enum\USBSTOR"
    Get-ChildItem -Path $regPath | ForEach-Object {
        $subKey = $_.PSPath
        Set-ItemProperty -Path $subKey -Name "Start" -Value 3
    }

    Write-Output "Tous les supports amovibles USB sont maintenant réactivés."
} else {
    # Bloquer les périphériques de stockage USB
    $regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\USBSTOR"
    Set-ItemProperty -Path $regPath -Name "Start" -Value 4

    # Désactiver les périphériques de stockage USB déjà installés
    $regPath = "HKLM:\SYSTEM\CurrentControlSet\Enum\USBSTOR"
    Get-ChildItem -Path $regPath | ForEach-Object {
        $subKey = $_.PSPath
        Set-ItemProperty -Path $subKey -Name "Start" -Value 4
    }

    Write-Output "Tous les supports amovibles USB sont maintenant bloqués."
}