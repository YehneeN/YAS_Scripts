[void][System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')


function Show-InputForm {
    param (
        [string]$DefaultNumeroCentre = "",
        [string]$DefaultNumeroPoste = ""
    )

    # Creation du formulaire
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "INTECH | Service Informatique"
    $form.Size = New-Object System.Drawing.Size(400,200)
    $form.StartPosition = "CenterScreen"

    # Creation des deux labels (n° centre + n° poste)
    $labelNumeroCentre = New-Object System.Windows.Forms.Label
    $labelNumeroCentre.Location = New-Object System.Drawing.Size(10,20)
    $labelNumeroCentre.Size = New-Object System.Drawing.Size(200,20)
    $labelNumeroCentre.Text = "Numero de centre (Exemple - 1250):"
    $form.Controls.Add($labelNumeroCentre)

    $labelNumeroPoste = New-Object System.Windows.Forms.Label
    $labelNumeroPoste.Location = New-Object System.Drawing.Size(10,50)
    $labelNumeroPoste.Size = New-Object System.Drawing.Size(200,20)
    $labelNumeroPoste.Text = "Numero du poste (1 ou 2):"
    $form.Controls.Add($labelNumeroPoste)

    # Creation des champs à remplir
    $textBoxNumeroCentre = New-Object System.Windows.Forms.TextBox
    $textBoxNumeroCentre.Location = New-Object System.Drawing.Size(220,20)
    $textBoxNumeroCentre.Size = New-Object System.Drawing.Size(150,20)
    $textBoxNumeroCentre.Text = $DefaultNumeroCentre
    $form.Controls.Add($textBoxNumeroCentre)

    $textBoxNumeroPoste = New-Object System.Windows.Forms.TextBox
    $textBoxNumeroPoste.Location = New-Object System.Drawing.Size(220,50)
    $textBoxNumeroPoste.Size = New-Object System.Drawing.Size(150,20)
    $textBoxNumeroPoste.Text = $DefaultNumeroPoste
    $form.Controls.Add($textBoxNumeroPoste)

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
        $NumeroCentre = $textBoxNumeroCentre.Text
        $NumeroPoste = $textBoxNumeroPoste.Text

        Write-Host "Numero de centre : $NumeroCentre"
        Write-Host "Numero du poste : $NumeroPoste"
		Write-Host "Le nom de l'ordinateur sera MIDFRC$NumeroCentre-$NumeroPoste"
		Set-Volume -DriveLetter C -NewFileSystemLabel "MIDFRC$NumeroCentre-$NumeroPoste"
		Rename-Computer -newname "MIDFRC$NumeroCentre-$NumeroPoste" -Restart
    }

    # 
    $form.Dispose()
}

# Lancement installation Sentinel
Start-Process powershell -Verb runAs -ArgumentList "-ExecutionPolicy Bypass -file C:\Tools\Scripts\Try_Sentinel.ps1" -NoNewWindow -Wait

# Lancement du formulaire
Show-InputForm -DefaultNumeroCentre "" -DefaultNumeroPoste ""