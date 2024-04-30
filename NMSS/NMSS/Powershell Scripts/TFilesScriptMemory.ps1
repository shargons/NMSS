# Specify the path to the directory
$dirPath = "Y:\M"

# Create a list to hold the file info
$fileInfoList = New-Object System.Collections.Generic.List[object]

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

    # Add the file info to the list
    $fileInfoList.Add($fileInfo)
}

# Export the file info list to a CSV file
$fileInfoList | Export-Csv -Path "outputM.csv" -NoTypeInformation