$RG = 'RG_AzProject_VMs'

#Checking if the Resurce Group ($RG) exists
$RGCheck = Get-AzResourceGroup -ResourceGroupName *
if ($RGCheck.ResourceGroupName -eq $RG) {
   Remove-AzResourceGroup -Name $RG -Force
   if ($RGCheck.ResourceGroupName -eq $RG)
   { Write-Host "$RG has been successfully removed!" -ForegroundColor Green }
   else
   { Write-Host "There is some problem with removing "$RG"! The group hasn't been removed!" -ForegroundColor Red }        
}
else 
{ Write-Host "$RG doesn't exist!" -ForegroundColor Red }