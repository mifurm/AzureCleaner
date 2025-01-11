# Login to Azure
Connect-AzAccount

# Get all Azure Cosmos DB accounts
$cosmosDbAccounts = Get-AzCosmosDBAccount

# Initialize an array to store unused Cosmos DB accounts
$unusedCosmosDbAccounts = @()

# Check each Cosmos DB account for collections and throughput usage
foreach ($account in $cosmosDbAccounts) {
    $resourceGroupName = $account.ResourceGroupName
    $accountName = $account.Name

    # Get the list of databases in the Cosmos DB account
    $databases = Get-AzCosmosDBSqlDatabase -ResourceGroupName $resourceGroupName -AccountName $accountName

    $hasCollections = $false
    $hasThroughputUsage = $false

    foreach ($database in $databases) {
        $collections = Get-AzCosmosDBSqlContainer -ResourceGroupName $resourceGroupName -AccountName $accountName -DatabaseName $database.Name
        if ($collections.Count -gt 0) {
            $hasCollections = $true
        }

        # Get the throughput usage
        $throughputUsage = Get-AzCosmosDBSqlThroughput -ResourceGroupName $resourceGroupName -AccountName $accountName -DatabaseName $database.Name
        if ($throughputUsage.CurrentThroughput -gt 0) {
            $hasThroughputUsage = $true
        }
    }

    if (-not $hasCollections -and -not $hasThroughputUsage) {
        $unusedCosmosDbAccounts += $account
    }
}

# Display the unused Cosmos DB accounts
$unusedCosmosDbAccounts | ForEach-Object {
    Write-Output "Azure Cosmos DB Account: $($_.Name) - Resource Group: $($_.ResourceGroupName)"
}