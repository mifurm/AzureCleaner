# Login to Azure
Connect-AzAccount

# Get all API Management services
$apiManagementServices = Get-AzApiManagement

# Initialize an array to store unused API Management services
$unusedApiManagementServices = @()

# Check each API Management service for APIs, products, and subscriptions
foreach ($apiMgmt in $apiManagementServices) {
    $apis = Get-AzApiManagementApi -ResourceGroupName $apiMgmt.ResourceGroupName -ServiceName $apiMgmt.Name
    $products = Get-AzApiManagementProduct -ResourceGroupName $apiMgmt.ResourceGroupName -ServiceName $apiMgmt.Name
    $subscriptions = Get-AzApiManagementSubscription -ResourceGroupName $apiMgmt.ResourceGroupName -ServiceName $apiMgmt.Name
    
    if ($apis.Count -eq 0 -and $products.Count -eq 0 -and $subscriptions.Count -eq 0) {
        $unusedApiManagementServices += $apiMgmt
    }
}

# Display the unused API Management services
$unusedApiManagementServices | ForEach-Object {
    Write-Output "API Management Service: $($_.Name) - Resource Group: $($_.ResourceGroupName)"
}