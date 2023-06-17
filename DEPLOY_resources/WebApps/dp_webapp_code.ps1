$RG = 'RG_AzProject_App'
$Subscription = (Get-AzSubscription).id
$Location = 'East US'
$Template = '.\DATA\ARM_Templates\webapp_code.json'

#Begin deploying
New-AzResourceGroup -Name $RG -Location $Location -Force

New-AzResourceGroupDeployment `
  -ResourceGroupName $RG `
  -TemplateFile $Template `
  -subscriptionId $Subscription `
  -serverFarmResourceGroup $RG