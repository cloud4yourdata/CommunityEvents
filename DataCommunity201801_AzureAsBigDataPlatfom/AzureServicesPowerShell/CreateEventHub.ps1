$SubscriptionName = "fb0d606c-7066-43ce-8b87-9112fe309305"
$ResGrpName = "bigdataplatform"
$Namespace  = "bdpmydevlabs"
$Location = "North Europe"
$EventHubName = "mydemodevices"
$ConsumerGroupName = "mdevices"
$AuthRuleName = "MyAuthRuleName"
$RootManageSharedAccessKey ="RootManageSharedAccessKey"
Login-AzureRmAccount
Select-AzureRmSubscription -SubscriptionName $SubscriptionName


$CurrentResourceGroupName = Get-AzureRmResourceGroup -Name $ResGrpName
if($CurrentResourceGroupName)
{
   Write-Host "The resourcegroup $ResGrpName already exists in the $Location region:"
}
else
{
 
    Write-Host "The $ResGrpName resourcegroup does not exist."
    Write-Host "Creating the $ResGrpName resourcegroup in the $Location region..."
    New-AzureRmResourceGroup -Name $ResGrpName -Location $Location
    $CurrentResourceGroupName = Get-AzureRmResourceGroup -Name $ResGrpName
    Write-Host "The $ResGrpName resourcegroup in the $Location region has been successfully created."
 
}



# Query to see if the namespace currently exists
$CurrentNamespace = Get-AzureRMEventHubNamespace -ResourceGroupName $ResGrpName -NamespaceName $Namespace 

# Check if the namespace already exists or needs to be created
if ($CurrentNamespace)
{
    Write-Host "The namespace $Namespace already exists in the $Location region:"
    # Report what was found
    Get-AzureRMEventHubNamespace -ResourceGroupName $ResGrpName -NamespaceName $Namespace
}
else
{
    Write-Host "The $Namespace namespace does not exist."
    Write-Host "Creating the $Namespace namespace in the $Location region..."
    New-AzureRmEventHubNamespace -ResourceGroupName $ResGrpName -NamespaceName $Namespace -Location $Location
    $CurrentNamespace = Get-AzureRMEventHubNamespace -ResourceGroupName $ResGrpName -NamespaceName $Namespace
    Write-Host "The $Namespace namespace in Resource Group $ResGrpName in the $Location region has been successfully created."
}

# Check if event hub already exists
$CurrentEH = Get-AzureRMEventHub -ResourceGroupName $ResGrpName -NamespaceName $Namespace -EventHubName $EventHubName

if($CurrentEH)
{
    Write-Host "The event hub $EventHubName already exists in the $Location region:"
    # Report what was found
    Get-AzureRmEventHub -ResourceGroupName $ResGrpName -NamespaceName $Namespace -EventHubName $EventHubName
}
else
{
    Write-Host "The $EventHubName event hub does not exist."
    Write-Host "Creating the $EventHubName event hub in the $Location region..."
    New-AzureRmEventHub -ResourceGroupName $ResGrpName -NamespaceName $Namespace -EventHubName $EventHubName -MessageRetentionInDays 3
    $CurrentEH = Get-AzureRmEventHub -ResourceGroupName $ResGrpName -NamespaceName $Namespace -EventHubName $EventHubName
    Write-Host "The $EventHubName event hub in Resource Group $ResGrpName in the $Location region has been successfully created."
}

# Check if consumer group already exists
$CurrentCG = Get-AzureRmEventHubConsumerGroup -ResourceGroupName $ResGrpName -NamespaceName $Namespace -EventHubName $EventHubName -ConsumerGroupName $ConsumerGroupName -ErrorAction Ignore

if($CurrentCG)
{
    Write-Host "The consumer group $ConsumerGroupName in event hub $EventHubName already exists in the $Location region:"
    # Report what was found
    Get-AzureRmEventHubConsumerGroup -ResourceGroupName $ResGrpName -NamespaceName $Namespace -EventHubName $EventHubName
}
else
{
    Write-Host "The $ConsumerGroupName consumer group does not exist."
    Write-Host "Creating the $ConsumerGroupName consumer group in the $Location region..."
    New-AzureRmEventHubConsumerGroup -ResourceGroupName $ResGrpName -NamespaceName $Namespace -EventHubName $EventHubName -ConsumerGroupName $ConsumerGroupName
    $CurrentCG = Get-AzureRmEventHubConsumerGroup -ResourceGroupName $ResGrpName -NamespaceName $Namespace -EventHubName $EventHubName
    Write-Host "The $ConsumerGroupName consumer group in event hub $EventHubName in Resource Group $ResGrpName in the $Location region has been successfully created."
}

Write-Host "Downloading information about configuration......."

$ep = Get-AzureRmEventHubKey -ResourceGroupName $ResGrpName -NamespaceName $Namespace -AuthorizationRuleName $RootManageSharedAccessKey
$ConnString = $ep.PrimaryConnectionString
$PrimaryKey = $ep.PrimaryKey;
Write-Host  "ConnectionString:$ConnString"
Write-Host  "Namespace: $Namespace"
Write-Host  "EventHub Name:" $EventHubName
Write-Host  "Primary Key:" $PrimaryKey
