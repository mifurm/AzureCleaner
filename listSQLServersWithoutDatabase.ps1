# Login to Azure
Connect-AzAccount

# Get all SQL servers
$sqlServers = Get-AzSqlServer

# Initialize an array to store SQL servers without databases
$emptySqlServers = @()

# Check each SQL server for databases
foreach ($server in $sqlServers) {
    $databases = Get-AzSqlDatabase -ResourceGroupName $server.ResourceGroupName -ServerName $server.ServerName
    
    if ($databases.Count -eq 0) {
        $emptySqlServers += $server
    }
}

# Display the SQL servers without databases
$emptySqlServers | ForEach-Object {
    Write-Output "SQL Server: $($_.ServerName) - Resource Group: $($_.ResourceGroupName)"
}
