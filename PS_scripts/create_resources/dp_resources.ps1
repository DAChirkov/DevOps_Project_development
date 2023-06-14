$RG = 'RG_AzProject'
$Location = 'East US 2'
$Template = '.\ARM_Templates\resources.json'  

#Begin deploying
New-AzResourceGroup -Name $RG -Location $Location -Force 

New-AzResourceGroupDeployment `
  -ResourceGroupName $RG `
  -TemplateFile $Template `
  -virtualNetworkName 'vNet-AzProject' `
  -subnetName 'SubNet-AzProject' `
  -networkSecurityGroupName 'NSG-AzProject' `
  -SSHStorageName 'SSHKeysForManage' `
  -SSHStorageNameClients 'SSHKeysForClients'