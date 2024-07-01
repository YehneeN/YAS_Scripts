# Path to files
$ateraMsiFile = "C:\ProgramData\Microsoft\SvcAtera\setup.msi"
$ateraMsiLink = #"Link to file, https"

if (-not (Test-Path -Path $ateraMsiFile)) {
    Invoke-WebRequest -Uri $ateraMsiLink -Outfile $ateraMsiFile}

# Verif. Atera Agent
if (Get-WmiObject -Query "SELECT * FROM Win32_Product WHERE Name = 'AteraAgent'" -ErrorAction SilentlyContinue){
} else {
    Start-Process msiexec.exe -ArgumentList "/i `"$ateraMsiFile`" /qn IntegratorLogin=xxxxxx@domain.tld CompanyId=Y AccountId=xxxx" -Wait
}
