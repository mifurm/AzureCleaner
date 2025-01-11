# Login to Azure
Connect-AzAccount

# Get all Azure Database for MySQL instances
$mysqlServers = Get-AzMySqlServer

# Initialize an array to store unused MySQL instances
$unusedMySqlInstances = @()

# Check each MySQL instance for active connections and recent queries
foreach ($server in $mysqlServers) {
    $resourceGroupName = $server.ResourceGroupName
    $serverName = $server.Name

    # Get the query performance insights
    $queryPerformance = Get-AzMySqlQueryPerformanceInsight -ResourceGroupName $resourceGroupName -ServerName $serverName -StartTime (Get-Date).AddDays(-30) -EndTime (Get-Date)

    # Check for active connections
    $activeConnections = Get-AzMySqlConnection -ResourceGroupName $resourceGroupName -ServerName $serverName

    if ($queryPerformance.Count -eq 0 -and $activeConnections.Count -eq 0) {
        $unusedMySqlInstances += $server
    }
}

# Display the unused MySQL instances
$unusedMySqlInstances | ForEach-Object {
    Write-Output "Azure Database for MySQL: $($_.Name) - Resource Group: $($_.ResourceGroupName)"
}
