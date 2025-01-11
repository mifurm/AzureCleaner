# Login to Azure
Connect-AzAccount

# Get all public IP addresses
$publicIPs = Get-AzPublicIpAddress

# Filter public IP addresses that are not assigned to any service
$unassignedPublicIPs = $publicIPs | Where-Object { $_.IpConfiguration -eq $null }

# Display the unassigned public IP addresses
$unassignedPublicIPs | ForEach-Object {
    Write-Output "Public IP Address: $($_.IpAddress) - Resource Group: $($_.ResourceGroupName)"
}