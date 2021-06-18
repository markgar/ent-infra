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

    Write-Host 'Command to execute:'
    Write-Host $commandToExecute

    # Invoke-Command -FilePath './rg/todo/deploy.ps1'

    Invoke-Command -ScriptBlock {
        $rgname = (Get-Location).Path.Split("/")[(Get-Location).Path.Split("/").Count-1]
        $rgname = "m-" + $rgname

        $deploymentName = Get-Date -Format "yyyyMMddHHmmss"

        az deployment sub create --location eastus --template-file ./rg/todo/main.bicep --name $deploymentName --parameters rgName=$rgname
    }
}

