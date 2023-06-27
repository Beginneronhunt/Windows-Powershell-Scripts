# Define the folder to scan
$folders = @("C:\", "D:\")

# Define the text or pattern to search
$pattern = "alok.chaudhary@42gears.com"

# Initialize an empty array to store the files
$files = @()

# Get all the .txt files in the folders and sub-folders that contain the pattern
foreach ($folder in $folders) {
    $folderFiles = Get-ChildItem -LiteralPath $folder -Filter "*.txt" -File -Recurse -ErrorAction SilentlyContinue |
                   Where-Object { $_ | Select-String -Pattern $pattern }
    $files += $folderFiles
}

# Export the selected properties of the files to a CSV file
$files | Select-Object Name, FullName, LastWriteTime | Export-Csv -Path "C:\results.csv" -NoTypeInformation -Append
