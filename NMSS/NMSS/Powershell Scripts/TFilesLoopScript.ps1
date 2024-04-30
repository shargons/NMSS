# Specify the path to the directory
$dirPath = "Y:\E"

# Initialize the file index
$fileIndex = 0

# Loop until there are no more files
while ($true) {
    # Get the next batch of 100 files
    $files = Get-ChildItem -Path $dirPath -File -Recurse |Select-Object -First 1000 -Skip $fileIndex

    # Break the loop if there are no more files
    if ($files.Count -eq 0) {
        break
    }

    # Create an array to hold the file info
    $fileInfoArray = @()

    # Process each file
    foreach ($file in $files) {
        # Get the full path of the file
        $filePath = $file.FullName
Write-Host "filePath: $filePath"

        # Get the content of the file and convert it to base64
        $fileContent = [System.Convert]::ToBase64String([System.IO.File]::ReadAllBytes($filePath))

        # Create a custom object to hold the file info
        $fileInfo = New-Object PSObject
        $fileInfo | Add-Member -MemberType NoteProperty -Name "FileName" -Value $file.Name
        $fileInfo | Add-Member -MemberType NoteProperty -Name "FilePath" -Value $filePath
        $fileInfo | Add-Member -MemberType NoteProperty -Name "FileContentBase64" -Value $fileContent

        # Add the file info to the array
        $fileInfoArray += $fileInfo
    }

    # Export the file info array to a CSV file
    $fileInfoArray | Export-Csv -Path "C:\Users\Sharon.gonsalves\Documents\outputE\output$fileIndex.csv" -NoTypeInformation

    # Update the file index
    $fileIndex += 1000
}
