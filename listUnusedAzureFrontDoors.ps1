# Login to Azure
Connect-AzAccount

# Get all Azure Front Doors
$frontDoors = Get-AzFrontDoor

# Initialize an array to store unused Front Doors
$unusedFrontDoors = @()

# Check each Front Door for configurations
foreach ($fd in $frontDoors) {
    $hasRoutingRules = $fd.RoutingRules.Count -gt 0
    $hasBackends = $fd.BackendPools.Count -gt 0
    $hasFrontendHosts = $fd.FrontendEndpoints.Count -gt 0

    if (-not $hasRoutingRules -and -not $hasBackends -and -not $hasFrontendHosts) {
        $unusedFrontDoors += $fd
    }
}

# Display the unused Front Doors
$unusedFrontDoors | ForEach-Object {
    Write-Output "Azure Front Door: $($_.Name) - Resource Group: $($_.ResourceGroupName)"
}