# Connect to Azure account
Connect-AzAccount

# Get all subscriptions in the tenant
$subscriptions = Get-AzSubscription

# Create an array to store VM details
$vmDetails = @()

foreach ($subscription in $subscriptions) {
    # Set the current subscription context
    Set-AzContext -SubscriptionId $subscription.Id

    # Get the list of VMs in the subscription
    $vms = Get-AzVM

    foreach ($vm in $vms) {
        # Get VM properties
        $vmName = $vm.Name
        $vmSize = $vm.HardwareProfile.VmSize
        $vmLocation = $vm.Location
        $vmResourceGroup = $vm.ResourceGroupName

        # Get Disks associated with the VM
        $disks = Get-AzDisk | Where-Object { $_.ManagedBy -eq $vm.Id }

        foreach ($disk in $disks) {
            $diskName = $disk.Name
            $diskSize = $disk.DiskSizeGB
            $diskSku = $disk.Sku.Name

            # Create a custom object to hold the details
            $vmDetail = [PSCustomObject]@{
                VMName          = $vmName
                VMSize          = $vmSize
                DiskName        = $diskName
                DiskSize        = $diskSize
                DiskSKU         = $diskSku
                Region          = $vmLocation
                ResourceGroup   = $vmResourceGroup
            }

            # Add the custom object to the array
            $vmDetails += $vmDetail
        }
    }
}

# Output the VM details in a table format
$vmDetails | Format-Table -AutoSize
