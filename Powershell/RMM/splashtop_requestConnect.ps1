# 

reg add "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Splashtop Inc.\Splashtop Remote Server" /v EnableSharePUC /t REG_DWORD /d 1 /f 
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Splashtop Inc.\Splashtop Remote Server" /v EnableSharePUC /t REG_DWORD /d 1 /f 

net stop "SplashtopRemoteService"
net start "SplashtopRemoteService" 
