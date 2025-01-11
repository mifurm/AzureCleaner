# Login to Azure
Connect-AzAccount

# Get all Application Gateways
$appGateways = Get-AzApplicationGateway

# Initialize an array to store unused Application Gateways
$unusedAppGateways = @()

# Check each Application Gateway for associated backend pools
foreach ($appGateway in $appGateways) {
    if ($appGateway.BackendAddressPools.Count -eq 0) {
        $unusedAppGateways += $appGateway
    }
}

# Display the unused Application Gateways
$unusedAppGateways | ForEach-Object {
    Write-Output "Application Gateway: $($_.Name) - Resource Group: $($_.ResourceGroupName)"
}

# Get all VNET Gateways
$vnetGateways = Get-AzVirtualNetworkGateway

# Initialize an array to store unused VNET Gateways
$unusedVnetGateways = @()

# Check each VNET Gateway for connections
foreach ($vnetGateway in $vnetGateways) {
    $connections = Get-AzVirtualNetworkGatewayConnection | Where-Object { $_.VirtualNetworkGateway1.Id -eq $vnetGateway.Id -or $_.VirtualNetworkGateway2.Id -eq $vnetGateway.Id }

    if ($connections.Count -eq 0) {
        $unusedVnetGateways += $vnetGateway
    }
}

# Display the unused VNET Gateways
$unusedVnetGateways | ForEach-Object {
    Write-Output "VNET Gateway: $($_.Name) - Resource Group: $($_.ResourceGroupName)"
}
