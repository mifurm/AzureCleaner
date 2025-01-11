#TODO: Probably need to add a check for the server status to ensure it is running before checking for connections

# Login to Azure
Connect-AzAccount

# Get all Azure Database for MySQL Flexible Server instances
$mysqlFlexibleServers = Get-AzMySqlFlexibleServer

# Initialize an array to store unused MySQL Flexible Server instances
$unusedMySqlFlexibleInstances = @()

# Check each MySQL Flexible Server instance for active connections and recent queries
foreach ($server in $mysqlFlexibleServers) {
    $resourceGroupName = $server.ResourceGroupName
    $serverName = $server.Name

    # Get the query performance insights
    $queryPerformance = Get-AzMySqlFlexibleServerQueryPerformanceInsight -ResourceGroupName $resourceGroupName -ServerName $serverName -StartTime (Get-Date).AddDays(-30) -EndTime (Get-Date)

    # Check for active connections
    $activeConnections = Get-AzMySqlFlexibleServerConnection -ResourceGroupName $resourceGroupName -ServerName $serverName

    if ($queryPerformance.Count -eq 0 -and $activeConnections.Count -eq 0) {
        $unusedMySqlFlexibleInstances += $server
    }
}

# Display the unused MySQL Flexible Server instances
$unusedMySqlFlexibleInstances | ForEach-Object {
    Write-Output "Azure Database for MySQL Flexible Server: $($_.Name) - Resource Group: $($_.ResourceGroupName)"
}
