#Connect-AzAccount

$RGName = "RG_AzProject"
$location = "eastus2"
$storageAccountName = "tfstate$(Get-Random)"
$containerName = "tfstate"

# Create resources
New-AzResourceGroup -Name $RGName -Location $location -Force 
$storageAccount = New-AzStorageAccount -ResourceGroupName $RGName -Name $storageAccountName -SkuName Standard_LRS -Location $location -Kind StorageV2 -AllowBlobPublicAccess $false

# Get access key
$storageAccountKeys = Get-AzStorageAccountKey -ResourceGroupName $RGName -Name $storageAccountName
$accessKey = $storageAccountKeys[0].Value

# Creating Blob container
New-AzStorageContainer -Name $containerName -Context $storageAccount.Context

$output =
@{
    storage_name   = $storageAccountName
    container_name = $containerName
    access_key     = $accessKey
}
$output | ConvertTo-Json

#############################################################################
#Need to create the secrets into the Repo
#AZURE_STORAGE_SECRET: secret value of your storage account
#############################################################################
