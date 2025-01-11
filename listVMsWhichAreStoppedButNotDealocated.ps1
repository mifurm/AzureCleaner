# Login to Azure
Connect-AzAccount

# Get all virtual machines
$vms = Get-AzVM

# Initialize an array to store stopped but not deallocated VMs
$stoppedNotDeallocatedVMs = @()

# Check each VM for its power state
foreach ($vm in $vms) {
    $vmStatus = Get-AzVM -ResourceGroupName $vm.ResourceGroupName -Name $vm.Name -Status
    $powerState = $vmStatus.Statuses | Where-Object { $_.Code -match "PowerState" }

    if ($powerState.DisplayStatus -eq "VM stopped") {
        $stoppedNotDeallocatedVMs += $vm
    }
}

# Display the stopped but not deallocated VMs
$stoppedNotDeallocatedVMs | ForEach-Object {
    Write-Output "VM Name: $($_.Name) - Resource Group: $($_.ResourceGroupName)"
}