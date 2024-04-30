# Specify the path to the directory
$dirPath = "Y:\C"
Write-Host "dirPath: $dirPath"

# Get all the directories
$dirs = Get-ChildItem -Path $dirPath -Directory -Recurse
Write-Host "dirs: $dirs"

# Check if there are any directories
if ($dirs.Count -eq 0) {
    Write-Output "No directories found in $dirPath"
    return
}

# Initialize the progress counter
$progressCount = 0

# Create a script block for the parallel operation
$scriptBlock = {
    param($dirs)

    # Create an array to hold the file info
    $fileInfoArray = @()

    # Get all the files in the directory
Get-ChildItem -Path $dirPath -File -Recurse | ForEach-Object {
    # Get the full path of the file
    $filePath = $_.FullName

        # Open the file in read mode
        $fileStream = [System.IO.File]::OpenRead($filePath)

        # Create a new instance of the ToBase64Transform class to convert to base64
        $base64Transform = [System.Security.Cryptography.ToBase64Transform]::new()

        # Create a buffer to hold the source bytes
        $buffer = New-Object byte[] $base64Transform.InputBlockSize

        # Create a byte array to hold the transformed bytes
        $transformedBytes = New-Object byte[] $base64Transform.OutputBlockSize

        # Create a StringBuilder to hold the base64 string
        $base64StringBuilder = [System.Text.StringBuilder]::new()

        # Read the file in chunks and convert each chunk to base64
        while (($inputCount = $fileStream.Read($buffer, 0, $buffer.Length)) -gt 0) {
            $outputCount = $base64Transform.TransformBlock($buffer, 0, $inputCount, $transformedBytes, 0)
            $base64StringBuilder.Append([System.Text.Encoding]::ASCII.GetString($transformedBytes, 0, $outputCount))
        }

        # Transform the final block of data
        $transformedBytes = $base64Transform.TransformFinalBlock($buffer, 0, $inputCount)
        $base64StringBuilder.Append([System.Text.Encoding]::ASCII.GetString($transformedBytes))

        # Close the file stream and the base64 transform
        $fileStream.Close()
        $base64Transform.Clear()

        # Get the base64 string
        $fileContent = $base64StringBuilder.ToString()

        # Create a custom object to hold the file info
        $fileInfo = New-Object PSObject
        $fileInfo | Add-Member -MemberType NoteProperty -Name "FileName" -Value $_.Name
        $fileInfo | Add-Member -MemberType NoteProperty -Name "FilePath" -Value $filePath
        $fileInfo | Add-Member -MemberType NoteProperty -Name "FileContentBase64" -Value $fileContent

        # Add the file info to the array
        $fileInfoArray += $fileInfo
    }

    # Export the file info array to a CSV file
    $fileInfoArray | Export-Csv -Path "outputC.csv" -NoTypeInformation

    # Update the progress counter
    $script:progressCount++

    # Display the progress
    Write-Progress -Activity "Generating CSV files" -Status "Processing directory $dir" 

    # Force a garbage collection to free up memory
    [System.GC]::Collect()
}

# Process each directory in parallel
$dirs | ForEach-Object -Parallel $scriptBlock -ThrottleLimit 5
