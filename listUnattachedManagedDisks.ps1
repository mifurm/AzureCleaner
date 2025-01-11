# Login to Azure
Connect-AzAccount

# Get all managed disks
$managedDisks = Get-AzDisk

# Filter managed disks that are not attached to any VM
$unattachedDisks = $managedDisks | Where-Object { $_.ManagedBy -eq $null }

# Display the unattached managed disks
$unattachedDisks | ForEach-Object {
    Write-Output "Managed Disk: $($_.Name) - Resource Group: $($_.ResourceGroupName)"
}