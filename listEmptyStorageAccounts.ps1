# Login to Azure
Connect-AzAccount

# Get all storage accounts
$storageAccounts = Get-AzStorageAccount

# Initialize an array to store empty storage accounts
$emptyStorageAccounts = @()

# Check each storage account for data
foreach ($account in $storageAccounts) {
    $context = $account.Context
    $blobContainers = Get-AzStorageContainer -Context $context

    $hasData = $false

    foreach ($container in $blobContainers) {
        $blobs = Get-AzStorageBlob -Context $context -Container $container.Name
        if ($blobs.Count -gt 0) {
            $hasData = $true
            break
        }
    }

    if (-not $hasData) {
        $emptyStorageAccounts += $account
    }
}

# Display the empty storage accounts
$emptyStorageAccounts | ForEach-Object {
    Write-Output "Storage Account: $($_.StorageAccountName) - Resource Group: $($_.ResourceGroupName)"
}
