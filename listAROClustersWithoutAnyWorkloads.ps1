# TODO: 
# This script will not identify any clusters probably as in the system namespace there are always some workloads running. 
# Need to find a way to exclude system namespace from the list of workloads.

# Login to Azure
Connect-AzAccount

# Get all ARO clusters
$aroClusters = Get-AzAroCluster

# Initialize an array to store unused ARO clusters
$unusedAroClusters = @()

# Check each ARO cluster for nodes and workloads
foreach ($aroCluster in $aroClusters) {
    $resourceGroupName = $aroCluster.ResourceGroupName
    $aroClusterName = $aroCluster.Name

    # Get the nodes in the ARO cluster
    $nodes = Get-AzAroNode -ResourceGroupName $resourceGroupName -ClusterName $aroClusterName

    # Get the workloads in the ARO cluster using oc command
    $kubeconfig = (Get-AzAroKubeconfig -ResourceGroupName $resourceGroupName -Name $aroClusterName).Value
    & oc login --token=$kubeconfig
    $workloads = & oc get pods --all-namespaces

    if ($nodes.Count -eq 0 -and $workloads.Count -eq 0) {
        $unusedAroClusters += $aroCluster
    }
}

# Display the unused ARO clusters
$unusedAroClusters | ForEach-Object {
    Write-Output "ARO Cluster: $($_.Name) - Resource Group: $($_.ResourceGroupName)"
}