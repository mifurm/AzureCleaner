# Login to Azure
Connect-AzAccount

# Get all network security groups
$nsgs = Get-AzNetworkSecurityGroup

# Initialize an array to store unassociated NSGs
$unassociatedNSGs = @()

# Check each NSG for associations
foreach ($nsg in $nsgs) {
    $subnetAssociations = Get-AzVirtualNetwork | Where-Object { $_.Subnets.NetworkSecurityGroup.Id -eq $nsg.Id }
    $nicAssociations = Get-AzNetworkInterface | Where-Object { $_.NetworkSecurityGroup.Id -eq $nsg.Id }
    
    if ($subnetAssociations.Count -eq 0 -and $nicAssociations.Count -eq 0) {
        $unassociatedNSGs += $nsg
    }
}

# Display the unassociated NSGs
$unassociatedNSGs | ForEach-Object {
    Write-Output "Network Security Group: $($_.Name) - Resource Group: $($_.ResourceGroupName)"
}