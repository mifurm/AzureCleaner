# Login to Azure
Connect-AzAccount

# Get all App Service Plans
$appServicePlans = Get-AzAppServicePlan

# Initialize an array to store App Service Plans without apps
$emptyAppServicePlans = @()

# Check each App Service Plan for associated apps
foreach ($plan in $appServicePlans) {
    $webApps = Get-AzWebApp -ResourceGroupName $plan.ResourceGroupName -AppServicePlan $plan.Name

    if ($webApps.Count -eq 0) {
        $emptyAppServicePlans += $plan
    }
}

# Display the App Service Plans without apps
$emptyAppServicePlans | ForEach-Object {
    Write-Output "App Service Plan: $($_.Name) - Resource Group: $($_.ResourceGroupName)"
}
