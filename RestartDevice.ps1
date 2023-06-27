function Restart-device {    
$logpath = "C:\logs\servicestatus.log"
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Restart-Computer -Force
Add-Content -Path $logpath -Value "$timestamp Device Restart"  
#Autologin to Windows Account
# Set the registry values for auto-login
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
$defaultUsername = "Rajkot 42G"
$defaultPassword = "Test@1234"
Set-ItemProperty -Path $regPath -Name "AutoAdminLogon" -Value "1"
Set-ItemProperty -Path $regPath -Name "DefaultUsername" -Value $defaultUsername
Set-ItemProperty -Path $regPath -Name "DefaultPassword" -Value $defaultPassword
}
Start-Sleep -Seconds 300
Restart-device