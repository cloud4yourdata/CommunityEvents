$SubscriptionName = "fb0d606c-7066-43ce-8b87-9112fe309305"
$ResGrpName = "bigdataplatform"
#Login-AzureRmAccount
Select-AzureRmSubscription -SubscriptionName $SubscriptionName
Get-AzureRmResourceGroup -Name $ResGrpName | Remove-AzureRmResourceGroup -Verbose -Force
Write-Host "Resource Group $ResGrpName has been successfully removed."