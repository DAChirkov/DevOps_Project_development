$RG = 'RG_AzProject'
$Location = 'East US 2'
$Template = '.\ARM_Templates\resources.json'
$KeyForServers = Get-Content -Path ".\Public_keys\manage.txt"
$KeyForClients = Get-Content -Path ".\Public_keys\clients.txt"

#Begin deploying
New-AzResourceGroup -Name $RG -Location $Location -Force 

New-AzResourceGroupDeployment `
  -ResourceGroupName $RG `
  -TemplateFile $Template `
  -PublicKeyForServers $KeyForServers `
  -PublicKeyForClients $KeyForClients