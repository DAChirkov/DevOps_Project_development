$RG = 'RG_AzProject_App'
$Location = 'East US 2'
$KeyVault = 'KeyVault-WebApps-236113'
$KeyVaultSecret = 'GitHubAction-Token'
$Template = '.\DATA\ARM_Templates\WebApps\webapp_static.json'

#Begin deploying
New-AzResourceGroup -Name $RG -Location $Location -Force

#Purge deleting Key Vault and create a new one
Remove-AzKeyVault -VaultName $KeyVault -InRemovedState $Location -Force -ErrorAction SilentlyContinue

$KVCheck = Get-AzKeyVault -VaultName $KeyVault -ErrorAction SilentlyContinue
if ($KVCheck.VaultName -ne $KeyVault)
   {
      New-AzKeyVault `
        -Name $KeyVault `
        -ResourceGroupName $RG `
        -Location $Location `
        -EnabledForTemplateDeployment `
        -EnableRbacAuthorization 
   }

#Creating token for GitHub Action
$SecretCheck = Get-AzKeyVaultSecret -VaultName $KeyVault -Name $KeyVaultSecret -ErrorAction SilentlyContinue
if ($SecretCheck.Name -ne $KeyVaultSecret)
   {
      $Secret = Read-Host "Enter Token For GitHub" -AsSecureString
      Set-AzKeyVaultSecret `
        -Name $KeyVaultSecret `
        -VaultName $KeyVault `
        -SecretValue $Secret
   }

New-AzResourceGroupDeployment `
   -ResourceGroupName $RG `
   -TemplateFile $Template `
   -vaultName $KeyVault `
   -secretName $KeyVaultSecret

#Show Host Name
Get-AzStaticWebApp | Format-Table DefaultHostname, ResourceGroupName, Location