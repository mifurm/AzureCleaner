# Login to Azure
Connect-AzAccount

# Get all Log Analytics Workspaces
$workspaces = Get-AzOperationalInsightsWorkspace

# Initialize an array to store empty workspaces
$emptyWorkspaces = @()

# Check each workspace for data ingestion over a period (e.g., last 30 days)
foreach ($workspace in $workspaces) {
    $usage = Get-AzOperationalInsightsUsage -ResourceGroupName $workspace.ResourceGroupName -WorkspaceName $workspace.Name -StartTime (Get-Date).AddDays(-30) -EndTime (Get-Date)
    
    if ($usage.Total -eq 0) {
        $emptyWorkspaces += $workspace
    }
}

# Display the empty Log Analytics Workspaces
$emptyWorkspaces | ForEach-Object {
    Write-Output "Log Analytics Workspace: $($_.Name) - Resource Group: $($_.ResourceGroupName)"
}