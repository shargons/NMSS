# Define the folder containing the CSV files
$folder = "C:\Users\Sharon.gonsalves\Documents\outputC"

# Get all CSV files in the folder (excluding the merged output file)
$files = Get-ChildItem -Path $folder -Filter *.csv -Exclude "merged.csv"

# Initialize the merged data with the header from the first file
$mergedData = @()

# Process each file
foreach ($file in $files) {
    $currentFile = Import-Csv -Path $file.FullName
    if ($currentFile) {
        # Skip the header row for subsequent files
        $mergedData += $currentFile | Select-Object -Skip 1
    }
}

# Export the merged data to a new CSV file
if ($mergedData) {
    $mergedData | Export-Csv -Path "C:\Users\Sharon.gonsalves\Documents\merged.csv" -NoTypeInformation
    Write-Host "Merged CSV files successfully!"
} else {
    Write-Host "No data found in the CSV files."
}