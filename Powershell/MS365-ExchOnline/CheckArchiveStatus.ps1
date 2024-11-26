Clear-Host
Write-Host "========== Parametrage du script =========="
$userArchiveCheck = Read-Host "Adresse mail de l'utilisateur "

while($true){

$normal = Get-MailboxStatistics -Identity $userArchiveCheck | select @{N="Type";E={"Normal"}},ItemCount,TotalItemSize
$archive = Get-MailboxStatistics -Identity $userArchiveCheck -Archive | select @{N="Type";E={"Archive"}},ItemCount,TotalItemSize

clear-host;
Write-Host "========== Information sur la boite et l'archive de l'utilisateur =========="
Write-Host $userArchiveCheck
$result = @($normal) + @($archive)
write-host ($result | out-string);

start-sleep -s 60;

}