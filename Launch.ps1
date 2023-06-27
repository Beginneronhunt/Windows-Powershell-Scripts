$logpath = "C:\logs\servicestatus.log"
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
start-Process "C:\Program Files (x86)\42Gears\Nix Agent\SureMDM Agent.exe"
Add-Content -Path $logpath -Value "$timestamp App Launced"