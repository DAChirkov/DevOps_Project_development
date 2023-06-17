$RG = 'RG_AzProject_VMs_Manage'
$RG_resources = 'RG_AzProject'
$VM = 'VM-ANS-1'
$Location = 'East US 2'
$Template = '.\DATA\ARM_Templates\manage_vms.json'

#Checking if the Resurce Groups ($RG_resources) exist
$RGCheck = Get-AzResourceGroup -ResourceGroupName $RG_resources -ErrorAction SilentlyContinue
if ($RGCheck.ResourceGroupName -ne $RG_resources)
   {
      Write-Host "The $RG_resources doen't exists! Resource Group in the process of creation!" -ForegroundColor Green
      & .\PS_scripts\create_resources\dp_resources.ps1
   }

#Begin deploying
New-AzResourceGroup -Name $RG -Location $Location -Force

New-AzResourceGroupDeployment `
  -ResourceGroupName $RG `
  -TemplateFile $Template `
  -vmName $VM `
  -vmSize 'Standard_B1s'