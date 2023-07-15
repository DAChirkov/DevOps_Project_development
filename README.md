##### Status of Last Deployment:<br>
<img src="https://github.com/DAChirkov/DevOps_Project/actions/workflows/azure_infrastructure_terraform.yml/badge.svg"><br><br>
<img src="https://github.com/DAChirkov/DevOps_Project/actions/workflows/azure_infrastructure_ansible.yml/badge.svg"><br>
  
  
  
##### Step1 - Need to create a Service Principal  
```
AZURE_CLIENT_ID: client id value of your service principal
AZURE_CLIENT_SECRET: client secret value of your service principal  
AZURE_SUBSCRIPTION_ID: subscription id value of your service principal  
AZURE_TENANT_ID: tenant id value of your service principal

\Pre-requisites\Terraform\Service_principal.ps1  
```
##### Step2 - Need to create a Storage Account  
```
AZURE_STORAGE_SECRET: secret value of your storage account
 
\Pre-requisites\Terraform\Service_storage.ps1  
```
