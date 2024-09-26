# 

reg add "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Splashtop Inc.\Splashtop Remote Server" /v ReqPassword /t REG_DWORD /d 8 /f 
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Splashtop Inc.\Splashtop Remote Server" /v ReqPassword /t REG_DWORD /d 8 /f 

net stop "SplashtopRemoteService"
net start "SplashtopRemoteService" 
 