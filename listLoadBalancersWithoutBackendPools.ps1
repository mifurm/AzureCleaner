# Login to Azure
Connect-AzAccount

# Get all load balancers
$loadBalancers = Get-AzLoadBalancer

# Initialize an array to store load balancers with no backend pools
$emptyLoadBalancers = @()

# Check each load balancer for associated backend pools
foreach ($lb in $loadBalancers) {
    $backendPools = $lb.BackendAddressPools
    if ($backendPools.Count -eq 0) {
        $emptyLoadBalancers += $lb
    }
}

# Display the load balancers with no associated backend pools
$emptyLoadBalancers | ForEach-Object {
    Write-Output "Load Balancer: $($_.Name) - Resource Group: $($_.ResourceGroupName)"
}
