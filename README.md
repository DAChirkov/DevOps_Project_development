##### Status of Last Deployment:<br>
<img src="https://github.com/DAChirkov/DevOps_Project/actions/workflows/azure_infrastructure_terraform.yml/badge.svg"><br><br>
<img src="https://github.com/DAChirkov/DevOps_Project/actions/workflows/azure_infrastructure_ansible.yml/badge.svg"><br>

##### Azure infrastructure scheme:
![](https://github.com/DAChirkov/DevOps_Project/blob/8171ff6085caab7424e5adef67d08ece7806cddc/pre-requisites/other/azure_scheme.jpg)  
  
##### Required prerequisites for Azure:
```  
Step1 - Create SSH keys
--------
AZURE_SSH_KEY: generate new SSH keys and add client private SSH key 
Change:
- "variable "resource_ssh_servers_public_key" string in main variables.tf
- "variable "resource_ssh_clients_public_key" string in main variables.tf

Step2 - Create a Service Principal  
--------
AZURE_CLIENT_ID: client id value of your service principal
AZURE_CLIENT_SECRET: client secret value of your service principal  
AZURE_SUBSCRIPTION_ID: subscription id value of your service principal  
AZURE_TENANT_ID: tenant id value of your service principal
>>> \pre-requisites\terraform\Service_principal.ps1  

Step3 - Create a Storage Account  
--------
AZURE_STORAGE_SECRET: secret value of your storage account
>>> \pre-requisites\terraform\Service_storage.ps1  
```
