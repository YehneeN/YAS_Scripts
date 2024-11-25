############################################
#         YehneeN 2024 - INTECH IT         #
############################################

# Vérification de la connectivité vers le NAS
while (-not (Test-Connection -ComputerName "SYNOLAND00.land.act" -Count 1 -Quiet)) {
    Start-Sleep -Seconds 10
}

# Vérification lecteur M:
if (Test-Path -Path "M:\") {
    net use M: /delete /yes
}

# Lancemement GPUPDATE
gpupdate 

# Vérification lecteur M: 
if (Test-Path -Path "M:\") {
    net use
    $users = quser | ForEach-Object {
        $line = $_.ToString().Split(">", [System.StringSplitOptions]::RemoveEmptyEntries)[-1].Trim() 
        if ($line -match "^\s*(\S+)\s+(\S+)\s+\d+\s+actif") {
            $matches[1]
        }
    }
    foreach ($user in $users) {
        if ($user -ne "") {
            msg.exe $user "Les archives ont été remontées et sont à nouveau disponible au travers du lecteur M. 
    INTECH - Service IT"
        }
    }
}

