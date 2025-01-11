# Login to Azure
Connect-AzAccount

# Get all Azure Firewalls
$firewalls = Get-AzFirewall

# Initialize an array to store unused firewalls
$unusedFirewalls = @()

# Check each firewall for rules
foreach ($firewall in $firewalls) {
    $hasNetworkRules = $firewall.NetworkRuleCollections.Count -gt 0
    $hasAppRules = $firewall.ApplicationRuleCollections.Count -gt 0
    $hasNatRules = $firewall.NatRuleCollections.Count -gt 0

    if (-not $hasNetworkRules -and -not $hasAppRules -and -not $hasNatRules) {
        $unusedFirewalls += $firewall
    }
}

# Display the unused firewalls
$unusedFirewalls | ForEach-Object {
    Write-Output "Azure Firewall: $($_.Name) - Resource Group: $($_.ResourceGroupName)"
}