# TODO: 
# This script will not identify any clusters probably as in the system namespace there are always some workloads running. 
# Need to find a way to exclude system namespace from the list of workloads.

# Login to Azure
Connect-AzAccount

# Get all AKS clusters
$aksClusters = Get-AzAks

# Initialize an array to store unused AKS clusters
$unusedAksClusters = @()

# Check each AKS cluster for nodes and workloads
foreach ($aksCluster in $aksClusters) {
    $resourceGroupName = $aksCluster.ResourceGroupName
    $aksClusterName = $aksCluster.Name

    # Get the nodes in the AKS cluster
    $nodes = Get-AzAksNodePool -ResourceGroupName $resourceGroupName -ClusterName $aksClusterName

    # Get the workloads in the AKS cluster using kubectl
    $kubeconfig = (Get-AzAksCredential -ResourceGroupName $resourceGroupName -Name $aksClusterName -Admin).Value
    $context = "az aks get-credentials --resource-group $resourceGroupName --name $aksClusterName --admin"
    & kubectl config use-context $context
    $workloads = & kubectl get pods --all-namespaces

    if ($nodes.Count -eq 0 -and $workloads.Count -eq 0) {
        $unusedAksClusters += $aksCluster
    }
}

# Display the unused AKS clusters
$unusedAksClusters | ForEach-Object {
    Write-Output "AKS Cluster: $($_.Name) - Resource Group: $($_.ResourceGroupName)"
}
