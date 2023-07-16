$RG = 'RG_AzProject_VMs'
$VMNameAnsible = 'VM-ANS-1'
$VMNameNginx = 'VM-FRN-1'
$Location = 'East US 2'
$VMSize = 'Standard_B1ls'
$NumberOfClients = Read-Host "Enter the number of backend VMs (0-3)"
$TemplateMain = '.\Archive\ARM\resources.json'
$TemplateFrontend = '.\Archive\ARM\frontend_vms.json'
$TemplateBackend = '.\Archive\ARM\backend_vms.json'
$KeyForServers = Get-Content -Path ".\Archive\SSH_public_keys\manage.txt"
$KeyForClients = Get-Content -Path ".\Archive\SSH_public_keys\clients.txt"

#Begin deploying
New-AzResourceGroup -Name $RG -Location $Location -Force 

#Deploying basic resources
New-AzResourceGroupDeployment `
  -ResourceGroupName $RG `
  -TemplateFile $TemplateMain `
  -PublicKeyForServers $KeyForServers `
  -PublicKeyForClients $KeyForClients

#Deploying an Ansible VM
New-AzResourceGroupDeployment `
  -ResourceGroupName $RG `
  -TemplateFile $TemplateFrontend `
  -vmName $VMNameAnsible `
  -vmSize $VMSize `
  -subnetName "SubNet1-AzProject" `
  -sshKeyName "SSHKeysForManage"

#Installing ansible
$Params = @{
  ResourceGroupName  = $RG
  VMName             = $VMNameAnsible
  Name               = 'CustomScript'
  Publisher          = 'Microsoft.Azure.Extensions'
  ExtensionType      = 'CustomScript'
  TypeHandlerVersion = '2.1'
  Settings           = @{fileUris = @('https://raw.githubusercontent.com/DAChirkov/DevOps_Project/main/Archive/ARM/Extensions/install_ansible.sh'); commandToExecute = 'sudo sh install_ansible.sh' }
}
Set-AzVMExtension @Params

#Deploying a Nginx VM
New-AzResourceGroupDeployment `
  -ResourceGroupName $RG `
  -TemplateFile $TemplateFrontend `
  -vmName $VMNameNginx `
  -vmSize $VMSize `
  -subnetName "SubNet2-AzProject"
-sshKeyName "SSHKeysForClients"

#Deploying backend VMs
if ($NumberOfClients -ne 0) {
  New-AzResourceGroupDeployment `
    -ResourceGroupName $RG `
    -TemplateFile $TemplateBackend `
    -numberOfInstances $NumberOfClients `
    -vmSize $VMSize
}

#Show IP-Addresses
 (Get-AzNetworkInterface -ResourceGroupName $RG).IpConfigurations.PrivateIpAddress