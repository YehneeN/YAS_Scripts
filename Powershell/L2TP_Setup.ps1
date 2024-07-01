#
# BIEN PENSER AUX VAR
#
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    $arguments = "& '" + $myinvocation.mycommand.definition + "'"
    Start-Process powershell -Verb runAs -ArgumentList $arguments
    Break
}
$VpnName = ""
$gateway = ""
$psk = ""
$regp = 'HKLM:\SYSTEM\CurrentControlSet\Services\PolicyAgent'
Add-VpnConnection -Name $VpnName -ServerAddress $gateway -TunnelType L2tp -AuthenticationMethod MSCHAPv2 -EncryptionLevel required -L2tpPsk $psk -Force -AllUserConnection -RememberCredential -UseWinlogonCredential
New-ItemProperty -Path $regp -Name AssumeUDPEncapsulationContextOnSendRule -Value 2 -PropertyType 'DWORD' -Force
ncpa.cpl
Set-ExecutionPolicy -ExecutionPolicy Restricted -Scope CurrentUser
Get-Process powershell | Stop-Process
