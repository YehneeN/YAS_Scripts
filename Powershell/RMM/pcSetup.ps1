#########################################################
#                                                       #
#	YehneeN                                             #
#	INTECH - 2024                                       #
#                                                       #
#########################################################

# Vérification des droits administratifs
If (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Le script n'est pas exécuté en tant qu'administrateur. Relance en cours..."
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    Exit
}

[void][System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')

Write-Progress -Activity "Définition des variables ..." -Status "Tâche 1 sur 11" -PercentComplete 0
Start-Sleep -Seconds 1

# Var
$LogSource = "Atera Mon. Events"
$eID = "00001"
$toolsFolderPath = ""
$ateraMsiFile = ""
$ateraMsiLink = ""
$ateraMsiFolder = ""
$ateraScript = ""

Write-Progress -Activity "Vérification du dossier Tools ..." -Status "Tâche 2 sur 11" -PercentComplete 10
Start-Sleep -Seconds 1

# Try Intech Tools Folder
if (-not (Test-Path -Path $toolsFolderPath)) {
    New-Item -ItemType Directory -Path $toolsFolderPath
    New-EventLog -LogName "Application" -Source $LogSource -ErrorAction SilentlyContinue
    Write-EventLog -LogName "Application" -Source $LogSource -EventID $eID -EntryType Information -Message "Création du dossier $toolsFolderPath."
}

Write-Progress -Activity "Vérification du dossier SvcAtera ..." -Status "Tâche 3 sur 11" -PercentComplete 20
Start-Sleep -Seconds 1

# Try Atera Folder & Agent
if (-not (Test-Path -Path $ateraMsiFolder)) {
    New-Item -ItemType Directory -Path $ateraMsiFolder
    New-EventLog -LogName "Application" -Source $LogSource -ErrorAction SilentlyContinue
    Write-EventLog -LogName "Application" -Source $LogSource -EventID $eID -EntryType Information -Message "Création du dossier $ateraMsiFolder."
}

Write-Progress -Activity "Vérification du fichier d'installation de l'agent ..." -Status "Tâche 4 sur 11" -PercentComplete 30
Start-Sleep -Seconds 1

if (-not (Test-Path -Path $ateraMsiFile)) {
    Invoke-WebRequest -Uri $ateraMsiLink -Outfile $ateraMsiFile
    New-EventLog -LogName "Application" -Source $LogSource -ErrorAction SilentlyContinue
    Write-EventLog -LogName "Application" -Source $LogSource -EventID $eID -EntryType Information -Message "Téléchargement du fichier MSI Atera Agent."
}
if (Get-WmiObject -Query "SELECT * FROM Win32_Product WHERE Name = 'AteraAgent'" -ErrorAction SilentlyContinue){
} else {
    Start-Process msiexec.exe -ArgumentList "/i `"$ateraMsiFile`" /qn IntegratorLogin=****@******** CompanyId=** AccountId=***********" -Wait
    New-EventLog -LogName "Application" -Source $LogSource -ErrorAction SilentlyContinue
    Write-EventLog -LogName "Application" -Source $LogSource -EventID $eID -EntryType Information -Message "Installation Atera Agent."
}

Write-Progress -Activity "Création du script Try_Atera ..." -Status "Tâche 5 sur 11" -PercentComplete 40
Start-Sleep -Seconds 1

# Création Try_Atera.ps1
if (-not (Test-Path -Path $ateraScript)) {
    $content = @"
# Attendre que le réseau soit disponible
while (-not (Test-Connection -ComputerName "8.8.8.8" -Count 1 -Quiet)) {
    Start-Sleep -Seconds 10
}
# Try Atera Folder & Agent
if (-not (Test-Path -Path "")) {
    New-Item -ItemType Directory -Path ""
}
if (-not (Test-Path -Path "")) {
    Invoke-WebRequest -Uri "" -Outfile ""}
if (Get-WmiObject -Query "SELECT * FROM Win32_Product WHERE Name = 'AteraAgent'" -ErrorAction SilentlyContinue){
} else {
    Start-Process msiexec.exe -ArgumentList "/i `"`" /qn IntegratorLogin= CompanyId=42 AccountId=" -Wait
}
"@
    New-Item -ItemType File -Path $ateraScript
    Set-Content -Path $ateraScript -Value $content
}

Write-Progress -Activity "Création de la tâche Try_Atera planifiée au démarrage du poste ..." -Status "Tâche 6 sur 11" -PercentComplete 50
Start-Sleep -Seconds 1

## Créer la tâche planifiée @ boot
$action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-File `"`""
$trigger = New-ScheduledTaskTrigger -AtStartup
$principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable
Register-ScheduledTask -TaskName "RunAteraScriptAtStartup" -Action $action -Trigger $trigger -Principal $principal -Settings $settings

Write-Progress -Activity "Modification des paramètres d'alimentation ..." -Status "Tâche 7 sur 11" -PercentComplete 60
Start-Sleep -Seconds 1

# Modifications des paramètres d'alimentation
function PowerM {
    POWERCFG -DUPLICATESCHEME 381b4222-f694-41f0-9685-ff5bb260df2e 381b4222-f694-41f0-9685-ff5bb260aaaa
    POWERCFG -CHANGENAME 381b4222-f694-41f0-9685-ff5bb260aaaa "Power Management"
    POWERCFG -SETACTIVE 381b4222-f694-41f0-9685-ff5bb260aaaa
    POWERCFG -CHANGE -monitor-timeout-ac 15
    POWERCFG -CHANGE -monitor-timeout-dc 5
    POWERCFG -CHANGE -disk-timeout-ac 30
    POWERCFG -CHANGE -disk-timeout-dc 5
    POWERCFG -CHANGE -standby-timeout-ac 0
    POWERCFG -CHANGE -standby-timeout-dc 30
    POWERCFG -CHANGE -hibernate-timeout-ac 0
    POWERCFG -CHANGE -hibernate-timeout-dc 0
}

PowerM

Write-Progress -Activity "Tweaking Windows (Fastboot, Sense, Télémétrie & Feedback OFF) ..." -Status "Tâche 8 sur 11" -PercentComplete 70
Start-Sleep -Seconds 1

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

Write-Progress -Activity "Définition des infos OEM ..." -Status "Tâche 9 sur 11" -PercentComplete 90
Start-Sleep -Seconds 1

# OEM Info
New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" -Name "Manufacturer" -Value ""  -PropertyType "String" -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" -Name "SupportHours" -Value ""  -PropertyType "String" -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" -Name "SupportPhone" -Value ""  -PropertyType "String" -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" -Name "SupportURL" -Value ""  -PropertyType "String" -Force

function Show-InputForm {
    param (
        [string]$DefaultName = ""
    )

    # Creation du formulaire
    $form = New-Object System.Windows.Forms.Form
    $form.Text = ""
    $form.Size = New-Object System.Drawing.Size(400,200)
    $form.StartPosition = "CenterScreen"

    # Creation des deux labels (n° centre + n° poste)
    $labelCompName = New-Object System.Windows.Forms.Label
    $labelCompName.Location = New-Object System.Drawing.Size(10,20)
    $labelCompName.Size = New-Object System.Drawing.Size(200,20)
    $labelCompName.Text = "Nom du poste: "
    $form.Controls.Add($labelCompName)

    # Creation des champs à remplir
    $textBoxCompName = New-Object System.Windows.Forms.TextBox
    $textBoxCompName.Location = New-Object System.Drawing.Size(220,50)
    $textBoxCompName.Size = New-Object System.Drawing.Size(150,20)
    $textBoxCompName.Text = $DefaultName
    $form.Controls.Add($textBoxCompName)

    # Bouton OK pour valider
    $buttonOK = New-Object System.Windows.Forms.Button
    $buttonOK.Location = New-Object System.Drawing.Size(300,100)
    $buttonOK.Size = New-Object System.Drawing.Size(75,23)
    $buttonOK.Text = "OK"
    $buttonOK.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $form.Controls.Add($buttonOK)

    # Resultat du formulaire
    $result = $form.ShowDialog()

    # Si "OK" --> Appliquer le changement de nom
    if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
        # Recuperer les valeurs
        $nomduPoste = $textBoxCompName.Text

        Write-Host "Le nom de l'ordinateur sera $nomduPoste"
        Set-Volume -DriveLetter C -NewFileSystemLabel "$nomduPoste"
        New-EventLog -LogName "Application" -Source $LogSource -ErrorAction SilentlyContinue
        Write-EventLog -LogName "Application" -Source $LogSource -EventID $eID -EntryType Information -Message "Rename du poste : $nomduPoste."
        Rename-Computer -newname "$nomduPoste" -Restart
    }

    # 
    $form.Dispose()
}

Write-Progress -Activity "Désactivation du compte administrateur ..." -Status "Tâche 10 sur 11" -PercentComplete 95
Start-Sleep -Seconds 1

# Desac. Administrateur
net user Administrateur /active:no

Write-Progress -Activity "Formulaire de renommage ..." -Status "Tâche finale" -PercentComplete 99
Start-Sleep -Seconds 1

# Lancement du formulaire
Show-InputForm -DefaultName ""