
$editedFiles = @( git diff HEAD HEAD~ --name-only )
 Write-Host 'Edited files:'
 Write-Host $editedFiles

$editedFilesFiltered = $editedFiles -match "rg/*"

$directoriesWithChanges = `
$(foreach ($file in $editedFilesFiltered) {
    $file.split('/')[1]
}) | Get-Unique

Write-Host 'RGs to deploy:'
Write-Host $directoriesWithChanges

foreach ($directory in $directoriesWithChanges) {
    $dirToCheck = './rg/' + $directory
    # Get-ChildItem -Path $dirToCheck
    $commandToExecute = $dirToCheck + '/deploy.ps1'
    Invoke-Command -FilePath $commandToExecute
}

