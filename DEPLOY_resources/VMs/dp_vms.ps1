$RG = 'RG_AzProject_VMs'
$VMName = 'VM-ANS-1'
$Location = 'East US 2'
$MasterSize = 'Standard_B1s'
#$SlaveSize = 'Standard_B1ls'
#$NumberOfClients = Read-Host "Enter the number of slave VMs"
$Template = '.\DATA\ARM_Templates\VMs\basic_resources.json'
$TemplateMVM = '.\DATA\ARM_Templates\VMs\master_vms.json'
#$TemplateCVM = '.\DATA\ARM_Templates\VMs\slave_vms.json'
$TemplateExtAns = '.\DATA\ARM_Templates\Extensions\ansible.json'
$KeyForServers = Get-Content -Path ".\DATA\Public_keys\manage.txt"
$KeyForClients = Get-Content -Path ".\DATA\Public_keys\clients.txt"

#Begin deploying
New-AzResourceGroup -Name $RG -Location $Location -Force 

#Deploying basic resources
#New-AzResourceGroupDeployment `
#  -ResourceGroupName $RG `
#  -TemplateFile $Template `
#  -PublicKeyForServers $KeyForServers `
#  -PublicKeyForClients $KeyForClients

#Deploying a VM to manage
#New-AzResourceGroupDeployment `
#  -ResourceGroupName $RG `
#  -TemplateFile $TemplateMVM `
#  -vmName $VMName `
#  -vmSize $MasterSize `
#Installing ansible

New-AzResourceGroupDeployment `
  -ResourceGroupName $RG `
  -TemplateFile $TemplateExtAns `
  -vmName $VMName `

#Set-AzVMExtension `
#  -VMName $VMName `
#  -ResourceGroupName $RG `
#  -Name $TemplateExtAns `
#  -ExtensionType "CustomScriptExtension"

#Deploying slave VMs
#New-AzResourceGroupDeployment `
#  -ResourceGroupName $RG `
#  -TemplateFile $TemplateCVM `
#  -numberOfInstances $NumberOfClients `
#  -vmSize $SlaveSize

#Show IP-Addresses
(Get-AzNetworkInterface -ResourceGroupName $RG).IpConfigurations.PrivateIpAddress