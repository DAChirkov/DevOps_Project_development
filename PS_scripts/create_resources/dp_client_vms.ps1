$RG = 'RG_AzProject_VMs_Clients'
$RG_resources = 'RG_AzProject'
$NumberOfClients = Read-Host "Enter the number of VMs"
$Location = 'East US 2'
$Template = '.\ARM_Templates\client_vms.json'

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
  -numberOfInstances $NumberOfClients `
  -vmSize 'Standard_B1ls'

#Show IP-Addresses
(Get-AzNetworkInterface -ResourceGroupName $RG).IpConfigurations.PrivateIpAddress