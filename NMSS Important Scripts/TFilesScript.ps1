# Specify the path to the directory
$dirPath = "Y:\B"

# Create an array to hold the file info
$fileInfoArray = @()

# Create an array to hold the names of files that caused errors
$errorFiles = @()

# Get all the files in the directory and its subdirectories
Get-ChildItem -Path $dirPath -File -Recurse | ForEach-Object {
    try {
        # Get the full path of the file
        $filePath = $_.FullName
        Write-Host "filePath: $filePath"

        # Get the content of the file and convert it to binary
        $fileContent = [System.IO.File]::ReadAllBytes($filePath)
        $fileContentBinary = [System.BitConverter]::ToString($fileContent) -replace '-', ''

        # Create a custom object to hold the file info
        $fileInfo = New-Object PSObject
        $fileInfo | Add-Member -MemberType NoteProperty -Name "FileName" -Value $_.Name
        $fileInfo | Add-Member -MemberType NoteProperty -Name "FilePath" -Value $filePath
        $fileInfo | Add-Member -MemberType NoteProperty -Name "FileContentBinary" -Value $fileContentBinary

        # Add the file info to the array
        $fileInfoArray += $fileInfo
    }
    catch {
        # If an error occurs, add the file name to the error files array
        $errorFiles += $_.Name
    }
}

# Export the file info array to a CSV file
$fileInfoArray | Export-Csv -Path "outputB.csv" -NoTypeInformation

# Output the names of the files that caused errors
if ($errorFiles.Count -gt 0) {
    Write-Host "The following files caused errors:"
    $errorFiles | ForEach-Object { Write-Host $_ }
} else {
    Write-Host "No files caused errors."
}