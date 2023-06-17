$RG = 'RG_AzProject_App'
$Location = 'East US'
$Repository = "https://github.com/DAChirkov/Static_WebApp"
$Branch = "main"
$Template = '.\DATA\ARM_Templates\webapp_static.json'

#Begin deploying
New-AzResourceGroup -Name $RG -Location $Location -Force

New-AzResourceGroupDeployment `
  -ResourceGroupName $RG `
  -TemplateFile $Template `
  -repositoryUrl $Repository `
  -branch $Branch
