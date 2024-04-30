# Specify the path to the directory
$dirPath = "Y:\M"

# Create an array to hold the file info
$fileInfoArray = @()

# Get all the files in the directory
Get-ChildItem -Path $dirPath -File -Recurse | ForEach-Object {
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

    # Add the file info to the array
    $fileInfoArray += $fileInfo
}

# Export the file info array to a CSV file
$fileInfoArray | Export-Csv -Path "outputM.csv" -NoTypeInformation