# Path to file 
$MsiFile = "C:\Tools\Logiciels\sentinelsetup.msi"

if (-not (Test-Path -Path $MsiFile)) {
    exit}

# Try Agent
if (Get-WmiObject -Query "SELECT * FROM Win32_Product WHERE Name = 'Sentinel Agent'" -ErrorAction SilentlyContinue){
} else {
    Start-Process msiexec.exe -ArgumentList "/i `"$MsiFile`" /qn /norestart SITE_TOKEN=''" -Wait
}

# Del file
del $MsiFile


