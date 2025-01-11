# Login to Azure
Connect-AzAccount

# Get all virtual networks
$virtualNetworks = Get-AzVirtualNetwork

# Initialize an array to store empty virtual networks
$emptyVirtualNetworks = @()

# Check each virtual network for attached devices
foreach ($vnet in $virtualNetworks) {
    $subnets = $vnet.Subnets
    $hasDevices = $false

    foreach ($subnet in $subnets) {
        $networkInterfaces = Get-AzNetworkInterface | Where-Object { $_.IpConfigurations.Subnet.Id -eq $subnet.Id }
        if ($networkInterfaces.Count -gt 0) {
            $hasDevices = $true
            break
        }
    }

    if (-not $hasDevices) {
        $emptyVirtualNetworks += $vnet
    }
}

# Display the empty virtual networks
$emptyVirtualNetworks | ForEach-Object {
    Write-Output "Virtual Network: $($_.Name) - Resource Group: $($_.ResourceGroupName)"
}