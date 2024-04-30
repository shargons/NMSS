# Specify the path to the directory
$dirPath = "Y:\M"

# Specify the path to the CSV file
$csvPath = "C:\Users\Sharon.gonsalves\Documents\outputM.csv"

# Read the CSV file
$csvContent = Import-Csv -Path $csvPath

# Create an array to hold the file info for files not in the CSV
$missingFiles = @()

# Check each file in the directory against the CSV
Get-ChildItem -Path $dirPath -File -Recurse | ForEach-Object {
    # Check if the file is in the CSV
    $fileInCsv = $csvContent | Where-Object { $_.FilePath -eq $_.FullName }

    # If the file is not in the CSV, add it to the missing files array
    if (-not $fileInCsv) {
        # Get the full path of the file
        $filePath = $_.FullName
        Write-Host "filePath: $filePath"

        # Get the content of the file and convert it to base64
        $fileContent = [System.Convert]::ToBase64String([System.IO.File]::ReadAllBytes($filePath))

        # Create a custom object to hold the file info
        $fileInfo = New-Object PSObject
        $fileInfo | Add-Member -MemberType NoteProperty -Name "FileName" -Value $_.Name
        $fileInfo | Add-Member -MemberType NoteProperty -Name "FilePath" -Value $filePath
        $fileInfo | Add-Member -MemberType NoteProperty -Name "FileContentBase64" -Value $fileContent

        # Add the file info to the missing files array
        $missingFiles += $fileInfo
    }
}

# If there are missing files, export them to a new CSV
if ($missingFiles.Count -gt 0) {
    $missingFiles | Export-Csv -Path "missing_filesM.csv" -NoTypeInformation
} else {
    Write-Host "All files are present in the output CSV."
}