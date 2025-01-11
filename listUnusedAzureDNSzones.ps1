# Login to Azure
Connect-AzAccount

# Get all DNS zones
$dnsZones = Get-AzDnsZone

# Initialize an array to store unused DNS zones
$unusedDnsZones = @()

# Check each DNS zone for record sets
foreach ($zone in $dnsZones) {
    $recordSets = Get-AzDnsRecordSet -ResourceGroupName $zone.ResourceGroupName -ZoneName $zone.Name

    # Filter out default record sets (SOA and NS)
    $nonDefaultRecordSets = $recordSets | Where-Object { $_.RecordType -ne "SOA" -and $_.RecordType -ne "NS" }

    if ($nonDefaultRecordSets.Count -eq 0) {
        $unusedDnsZones += $zone
    }
}

# Display the unused DNS zones
$unusedDnsZones | ForEach-Object {
    Write-Output "DNS Zone: $($_.Name) - Resource Group: $($_.ResourceGroupName)"
}
