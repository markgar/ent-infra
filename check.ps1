
$editedFiles = @( git diff HEAD HEAD~ --name-only )
Write-Host "Edited files:"
Write-Host $editedFiles

$editedFilesFiltered = $editedFiles -match "rg/*"

Get-Unique  -InputObject $editedFilesFiltered

foreach ($file in $editedFilesFiltered) {
    
    Write-Host "Filtered file: $file"

}