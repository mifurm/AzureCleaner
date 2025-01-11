# Login to Azure
Connect-AzAccount

# Get all Virtual WANs
$virtualWANs = Get-AzVirtualWan

# Initialize an array to store unused Virtual WANs
$unusedVirtualWANs = @()

# Check each Virtual WAN for associated hubs, sites, and connections
foreach ($vwan in $virtualWANs) {
    $hasHubs = ($vwan.VirtualHubs.Count -gt 0)
    $hasSites = ($vwan.VpnSites.Count -gt 0)
    $hasConnections = ($vwan.Connections.Count -gt 0)

    if (-not $hasHubs -and -not $hasSites -and -not $hasConnections) {
        $unusedVirtualWANs += $vwan
    }
}

# Display the unused Virtual WANs
$unusedVirtualWANs | ForEach-Object {
    Write-Output "Virtual WAN: $($_.Name) - Resource Group: $($_.ResourceGroupName)"
}