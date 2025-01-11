# Login to Azure
Connect-AzAccount

# Get all Bastion hosts
$bastions = Get-AzBastion

# Initialize an array to store unused Bastions
$unusedBastions = @()

# Check each Bastion for active sessions or connections
foreach ($bastion in $bastions) {
    $sessions = Get-AzBastionSession -ResourceGroupName $bastion.ResourceGroupName -Name $bastion.Name

    if ($sessions.Count -eq 0) {
        $unusedBastions += $bastion
    }
}

# Display the unused Bastion services
$unusedBastions | ForEach-Object {
    Write-Output "Bastion: $($_.Name) - Resource Group: $($_.ResourceGroupName)"
}