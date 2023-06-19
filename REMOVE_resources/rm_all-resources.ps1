$RG1 = 'RG_AzProject_VMs'
$RG2 = 'RG_AzProject_App'
$ListOfRGs = @($RG2,$RG1)

#Checking if the Resurce Groups exist and their deleting
$RGCheck = Get-AzResourceGroup -ResourceGroupName *

foreach ($i in $ListOfRGs)
   {
   if ($RGCheck.ResourceGroupName -eq $i)
      {
         Remove-AzResourceGroup -Name $i -Force
         if ($rgcheck.ResourceGroupName -eq $i)
            {Write-Host "$i has been successfully removed!" -ForegroundColor Green}
         else 
            {Write-Host "There is some problem with removing "$i"! The group hasn't been removed!" -ForegroundColor Red}        
      }
   else 
      {Write-Host "$i doesn't exist!" -ForegroundColor Red}
   }