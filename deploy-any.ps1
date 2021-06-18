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

    Invoke-Command -ScriptBlock {
        $rgname = "m-" + $directory

        $deploymentName = Get-Date -Format "yyyyMMddHHmmss"
        $templateFilePath = './rg-generic/' + $directory + '/main.bicep'
        $dirToCheck = './rg-generic/' + $directory

        Write-Host $dirToCheck
        Get-ChildItem $dirToCheck -Name
        $parametersFileList = Get-ChildItem $dirToCheck -Name
        
        if ($parametersFileList.Length -gt 0)
        {
            Write-Host "Try with Parameters"
            $parameterFilePath = './rg-generic/' + $directory + '/main.parameters.json'
            az deployment sub create --location eastus --template-file $templateFilePath --name $deploymentName --parameters $parameterFilePath --parameters rgName=$rgname
        }
        else {
            az deployment sub create --location eastus --template-file $templateFilePath --name $deploymentName --parameters rgName=$rgname
        }
        
    }
}

