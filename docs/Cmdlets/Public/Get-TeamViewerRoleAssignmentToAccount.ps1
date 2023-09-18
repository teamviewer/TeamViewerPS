function Get-TeamViewerRoleAssignmentToAccount {
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerUserRoleId } )]
        [Alias('UserRole')]
        [string]
        $UserRoleId
    )


    $resourceUri = "$(Get-TeamViewerApiUri)/userroles/assignments/account?userRoleId=$UserRoleId"
    $parameters = $null
    do {
        $response = Invoke-TeamViewerRestMethod `
            -ApiToken $ApiToken `
            -Uri $resourceUri `
            -Method Get `
            -Body $parameters `
            -WriteErrorTo $PSCmdlet `
            -ErrorAction Stop
        if ($response.ContinuationToken) {
            $resourceUri += '&continuationToken=' + $response.ContinuationToken
        }
        Write-Output ($response.AssignedToUsers | ConvertTo-TeamViewerRoleAssignedUser )
    }while ($response.ContinuationToken)
}
