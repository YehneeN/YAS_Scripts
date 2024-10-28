#################################################################
#
#   Modifications de paramètres suite à installation W11
#       Pour MDT/WDS - Suite rename - W.I.P.
#
#   YehneeN -2024
#################################################################

# Var
$LogSource = "Atera Monitoring Events"
$eID = "10000"

# Fonctions
#function LayoutDesign {
#    If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
#        Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
#        Exit
#    }
#    Import-StartLayout -LayoutPath "CheminVersLeFichierLayout.xml" -MountPath $env:SystemDrive\
#    }

#function oemInf {
#    Invoke-WebRequest -Uri "CheminVers\Intech.bmp" -OutFile "c:\windows\system32\Intech.bmp"
#    New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" -Name "Manufacturer" -Value "Intech"  -PropertyType "String" -Force
#    }

# Modifications des paramètres d'alimentation
#function IntechPower {
#    POWERCFG -DUPLICATESCHEME 381b4222-f694-41f0-9685-ff5bb260df2e 381b4222-f694-41f0-9685-ff5bb260aaaa
#    POWERCFG -CHANGENAME 381b4222-f694-41f0-9685-ff5bb260aaaa "Intech Power Management"
#    POWERCFG -SETACTIVE 381b4222-f694-41f0-9685-ff5bb260aaaa
#    POWERCFG -CHANGE -monitor-timeout-ac 15
#    POWERCFG -CHANGE -monitor-timeout-dc 5
#    POWERCFG -CHANGE -disk-timeout-ac 30
#    POWERCFG -CHANGE -disk-timeout-dc 5
#    POWERCFG -CHANGE -standby-timeout-ac 0
#    POWERCFG -CHANGE -standby-timeout-dc 30
#    POWERCFG -CHANGE -hibernate-timeout-ac 0
#    POWERCFG -CHANGE -hibernate-timeout-dc 0
#}

# Debloat de certaines applis Windows 
Write-Host "Désinstallation de certaines applications Windows inutiles..."
Get-AppxPackage "Microsoft.3DBuilder" | Remove-AppxPackage
Get-AppxPackage "Microsoft.BingFinance" | Remove-AppxPackage
Get-AppxPackage "Microsoft.BingNews" | Remove-AppxPackage
Get-AppxPackage "Microsoft.BingSports" | Remove-AppxPackage
Get-AppxPackage "Microsoft.BingWeather" | Remove-AppxPackage
Get-AppxPackage "Microsoft.Getstarted" | Remove-AppxPackage
Get-AppxPackage "Microsoft.MicrosoftOfficeHub" | Remove-AppxPackage
Get-AppxPackage "Microsoft.MicrosoftSolitaireCollection" | Remove-AppxPackage
Get-AppxPackage "Microsoft.People" | Remove-AppxPackage
Get-AppxPackage "Microsoft.Windows.Photos" | Remove-AppxPackage
Get-AppxPackage "Microsoft.WindowsAlarms" | Remove-AppxPackage
Get-AppxPackage "Microsoft.WindowsMaps" | Remove-AppxPackage
Get-AppxPackage "Microsoft.WindowsPhone" | Remove-AppxPackage
Get-AppxPackage "Microsoft.XboxApp" | Remove-AppxPackage
Get-AppxPackage "Microsoft.ZuneMusic" | Remove-AppxPackage
Get-AppxPackage "Microsoft.ZuneVideo" | Remove-AppxPackage
Get-AppxPackage "king.com.CandyCrushSodaSaga" | Remove-AppxPackage
Get-AppxPackage "king.com.CandyCrushSaga" | Remove-AppxPackage
Get-AppxPackage "king.com.CandyCrushFriends" | Remove-AppxPackage

# Désactivation fastboot Windows
Write-Host "Désactivation du démarrage rapide Windows..."
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power" -Name "HiberbootEnabled" -Value "0"

# Désactivation de la fonctionnalité Wi-Fi Sense
Write-Host "Désactivation de la fonctionnalité Wi-Fi Sense..."
If (!(Test-Path "HKLM:\Software\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting")) {
    New-Item -Path "HKLM:\Software\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting" -Force | Out-Null
}
Set-ItemProperty -Path "HKLM:\Software\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting" -Name "Value" -Type DWord -Value 0
Set-ItemProperty -Path "HKLM:\Software\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots" -Name "Value" -Type DWord -Value 0

# Désactivation télémétrie Windows
Write-Host "Désactivation de la télémétrie Windows..."
Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 0

# Désactiver Bing dans le Menu démarrer
Write-Host "Désactivation de Bing Search dans le menu démarrer..."
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "BingSearchEnabled" -Type DWord -Value 0

# Désactivation W. Feedback
Write-Host "Désactivation de Windows Feedback..."
If (!(Test-Path "HKCU:\Software\Microsoft\Siuf\Rules")) {
    New-Item -Path "HKCU:\Software\Microsoft\Siuf\Rules" -Force | Out-Null
}
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Siuf\Rules" -Name "NumberOfSIUFInPeriod" -Type DWord -Value 0

# Désactivation de l'ID publicitaire
Write-Host "Désactivation de l'identifiant publicitaire..."
If (!(Test-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo")) {
    New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" | Out-Null
}
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Name "Enabled" -Type DWord -Value 0

# Restriction des updates Windows en P2P au réseau local uniquement
Write-Host "Restriction des updates Windows en P2P au réseau local uniquement..."
Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" -Name "DODownloadMode" -Type DWord -Value 1
If (!(Test-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\DeliveryOptimization")) {
    New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\DeliveryOptimization" | Out-Null
}
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\DeliveryOptimization" -Name "SystemSettingsDownloadMode" -Type DWord -Value 3

# Changement de la vue par défaut de l'explorateur de fichier
Write-Host "Changement de la vue par défaut de l'explorateur de fichiers..."
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo" -Type DWord -Value 1


# Modification du layout Win11 pour les utilisateurs + Branding OEM
# LayoutDesign
# oemInf

# Verifications et Logging
#   IF OK COND 1
#       New-EventLog -LogName "Application" -Source $LogSource -EventID $eID -EntryType Information -Message "Message"
#   ELSE    New-EventLog -LogName "Application" -Source $LogSource -EventID $eID -EntryType Information -Message "Autre Message"
#
#    etc....
#


# Call rename automatique - YYYY-SN