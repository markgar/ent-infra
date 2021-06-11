$rgname = (Get-Location).Path.Split("/")[(Get-Location).Path.Split("/").Count-1]
$rgname = "m-" + $rgname

$deploymentName = Get-Date -Format "yyyyMMddHHmmss"

az deployment sub create --location eastus --template-file ./main.bicep --name $deploymentName --parameters ./main.parameters.json rgName=$rgname --name $deploymentName --mode complete