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

    $commandToExecute = $dirToCheck + '/deploy.ps1'

    Write-Host 'Command to execute:'
    Write-Host $commandToExecute

    Invoke-Command -ScriptBlock {
        $rgname = "m-" + $directory

        $deploymentName = Get-Date -Format "yyyyMMddHHmmss"
        $templateFilePath = './rg/' + $directory + '/main.bicep'
        az deployment sub create --location eastus --template-file $templateFilePath --name $deploymentName --parameters rgName=$rgname
    }
}

