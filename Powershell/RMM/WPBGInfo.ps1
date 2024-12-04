############################################
#         YehneeN 2024 - INTECH IT         #
#       After setup, save install date     #
############################################

# Vérification des droits administratifs
If (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Le script n'est pas exécuté en tant qu'administrateur. Relance en cours..."
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    Exit
}

# Var
$bgFolder = ""
$webDavUrl = ""
$username = ""
$password = ""
$credentials = New-Object System.Management.Automation.PSCredential ($username, (ConvertTo-SecureString $password -AsPlainText -Force))
$webDavUrlWithFile1 = "$webDavUrl/Bginfo64.exe"
$webDavUrlWithFile2 = "$webDavUrl/Template_Bginfo.bgi"
$webDavUrlWithFile3 = "$webDavUrl/img0.jpg"
$saveFilePath1 = "$bgFolder\Bginfo64.exe"
$saveFilePath2 = "$bgFolder\Template_Bginfo.bgi"
$img = "$bgFolder\img0.jpg"

# Vérification du dossier C:\ProgramData\Microsoft\SvcAtera
if (-Not (Test-Path -Path $bgFolder)) {
    New-Item -ItemType Directory -Path $bgFolder
}

if (Test-Path -Path $bgFolder) {
    # Téléchargement des fichiers
    if (-Not (Test-Path -Path $saveFilePath1)) {
        Invoke-WebRequest -Uri $webDavUrlWithFile1 -OutFile $saveFilePath1 -Credential $credentials -UseBasicParsing
    }
    if (-Not (Test-Path -Path $saveFilePath2)) {
        Invoke-WebRequest -Uri $webDavUrlWithFile2 -OutFile $saveFilePath2 -Credential $credentials -UseBasicParsing
    }
    if (-Not (Test-Path -Path $img)) {
        Invoke-WebRequest -Uri $webDavUrlWithFile3 -OutFile $img -Credential $credentials -UseBasicParsing
    }
}

# Définir le fond d'écran sur une image
function Set-Wallpaper {
    param (
        [string]$path
    )
    Add-Type -TypeDefinition @"
    using System;
    using System.Runtime.InteropServices;
    public class Wallpaper {
        [DllImport("user32.dll", CharSet = CharSet.Auto)]
        public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
    }
"@
    [Wallpaper]::SystemParametersInfo(0x0014, 0, $path, 0x0001 -bor 0x0002)
}

if (Test-Path -Path $saveFilePath1) {
    Set-Wallpaper -path $img
    # Définir le mode d'affichage du fond d'écran sur "Ajuster"
    Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name WallpaperStyle -Value 6
    Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name TileWallpaper -Value 0
    # Définir la couleur de fond sur blanc
    Set-ItemProperty -Path 'HKCU:\Control Panel\Colors' -Name Background -Value "0 0 0"
    # Rafraîchir les paramètres du bureau pour appliquer les changements
    RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters ,1 ,True

    # Lancer BGInfo
    Start-Process -FilePath "$saveFilePath1" -ArgumentList "$saveFilePath2 /accepteula /silent /timer 0"
}

