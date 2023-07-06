$subscription_id = (Get-AzSubscription).Id

$sp = New-AzADServicePrincipal -DisplayName "github-action-project"
$role = Get-AzRoleDefinition -Name "Contributor"
New-AzRoleAssignment -ObjectId $sp.Id -RoleDefinitionId $role.Id -Scope "/subscriptions/$subscription_id"

$creds = New-AzADSpCredential -ObjectId $sp.Id
$creds | ConvertTo-Json

#############################################################################
#Need to create the secrets into the Repo
#AZURE_CLIENT_ID: client id value of your service principal
#AZURE_CLIENT_SECRET: client secret value of your service principal
#AZURE_SUBSCRIPTION_ID: subscription id value of your service principal
#AZURE_TENANT_ID: tenant id value of your service principal
#############################################################################