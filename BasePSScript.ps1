function Launch-Nix {    
$logpath = "C:\logs\servicestatus.log"
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
start-Process "C:\Program Files (x86)\42Gears\Nix Agent\SureMDM Agent.exe"
Add-Content -Path $logpath -Value "$timestamp App Launced" 
}

function Get-NixServiceStatus { 
$servicename = "SureMDMService"
$logpath = "C:\logs\servicestatus.log"
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$status = Get-Service $servicename | Select-Object -ExpandProperty Status
if ($status -eq 'Running') {
        Add-Content -Path $logpath -Value "$timestamp $servicename status: $status"
				}
     else {
        Add-Content -Path $logpath -Value "$timestamp $servicename is stopped. Exiting script."
				}
}

function Shutdown-device {    
$logpath = "C:\logs\servicestatus.log"
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Stop-Computer -Force
Add-Content -Path $logpath -Value "$timestamp Device Shutdown" 
}

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

function Upgrade-Nix { 
$expectedVersion = "4.83.0"
$logpath = "C:\logs\servicestatus.log"
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

$appPackageNames = @(
# List of app package full names to upgrade
# Add more app package names as needed
"D:\Nix Agents\nixagentwin10v4.81.0.exe"
"D:\Nix Agents\nix_installer_winv4.89.0.exe"
"D:\Nix Agents\nixagentwin10v4.86.0.exe"
"D:\Nix Agents\nixagentwin10v4.87.0.exe"
)
foreach ($appPackageName in $appPackageNames) {
Start-Process -FilePath $appPackageName -ArgumentList "/verysilent"
Start-Sleep -Seconds 120
$upgradedVersion = Get-ItemProperty -Path "C:\Program Files (x86)\42Gears\Nix Agent\SureMDM Agent.exe" | Select-Object -ExpandProperty VersionInfo | Select-Object -ExpandProperty ProductVersion
Add-Content -Path $logpath -Value "$timestamp Nix successfully upgraded to: $upgradedVersion"  
} 
}

function Windows-Update { 
$logpath = "C:\logs\servicestatus.log"
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
#Install-Module PSWindowsUpdate
Import-Module PSWindowsUpdate
Get-WindowsUpdate -AcceptAll -Install 
Add-Content -Path $logpath -Value "$timestamp Windows Updated successfully: $upgradedVersion" 
}

function SqliteDBIntigrityCheck{
$logpath = "C:\logs\servicestatus.log"
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
# Then, you need to load the module into your session by running:
#Install-Module PSSQLite
Import-Module PSSQLite

# Specify the database file path and password
$Database = "C:\Program Files (x86)\42Gears\Nix Agent\Nix.sqlite"
$Password = "Phobos42Gears#" | ConvertTo-SecureString -AsPlainText -Force

# Connect to the encrypted database with the password
$Connection = New-SqliteConnection -DataSource $Database -Password $Password

#After that, you can use the Invoke-SQLiteQuery cmdlet to execute any SQL statement on an SQLite database. For example:

# Execute a query using Invoke-SqliteQuery cmdlet
$Query = "PRAGMA integrity_check"
$Results = Invoke-SqliteQuery -Connection $Connection -Query $Query

# Display the results
Add-Content -Path $logpath -Value "$timestamp Sqlite integrity_check: $Results" 

# Close the connection
$Connection.Close()
}

# Define the number of times to run the scripts
$numberOfTimes = 10

# Loop to run the scripts multiple times
for ($i = 1; $i -le $numberOfTimes; $i++) {
    Write-Host "Iteration $i"
		
    
# Call the scripts in sequence
#1. Launch Nix
#Launch-Nix

#2. Check Nix Service
Get-NixServiceStatus
Start-Sleep -Seconds 100
#3. Restart Device
#Restart-device

#4. Check Nix Service
#Get-NixServiceStatus

#5. Upgrade-Nix
Upgrade-Nix
Start-Sleep -Seconds 100
SqliteDBIntigrityCheck
Start-Sleep -Seconds 100

#Get-NixServiceStatus

#7. Windows-Update
Windows-Update
Start-Sleep -Seconds 100

#8. Check Nix Service
#Get-NixServiceStatus

#9. Shutdown-device
#Shutdown-device

#10. Check Nix Service
#Get-NixServiceStatus
}