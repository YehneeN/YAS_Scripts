############################################
#         YehneeN 2024 - INTECH IT         #
############################################

$adminGroup = [ADSI]"WinNT://./Administrateurs,group"

# Grab les admins
$adminMembers = $adminGroup.psbase.Invoke("Members") | foreach {
    $_.GetType().InvokeMember("Name", 'GetProperty', $null, $_, $null)
}

Write-Host "__________________________"
Write-Host "Liste des administrateurs avant nettoyage : "

# Lister les admins et supprimer si ne correspond pas à 
# INFORMATIQUE, Administrateur ou Admins du domaine
$adminMembers | foreach {
    Write-Host "$_"
    if($_ -notlike "INFORMATIQUE") {
        if($_ -notlike "Administrateur") {
            if($_ -notlike "Admins du domaine") {
            Remove-LocalGroupMember -Group "Administrateurs" -Member $_}}}
}

Write-Host "__________________________"
Write-Host "Liste des administrateurs apres nettoyage : "

# Liste mise à jour
$adminMembers = $adminGroup.psbase.Invoke("Members") | foreach {
    $_.GetType().InvokeMember("Name", 'GetProperty', $null, $_, $null)
}
$adminMembers | Foreach {
Write-Host "$_"
}