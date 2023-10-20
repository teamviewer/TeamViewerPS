function Get-TeamViewerUserGroupByRole {
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript({ $_ | Resolve-TeamViewerRoleId })]
        [Alias('UserRole')]
        [string]
        $RoleId
    )

    Begin {
        $resourceUri = "$(Get-TeamViewerApiUri)/userroles/assignments/usergroups?userRoleId=$RoleId"
        $parameters = $null
    }
    Process {
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
            Write-Output ($response.AssignedToGroups | ConvertTo-TeamViewerRoleAssignedUserGroup )
        }while ($response.ContinuationToken)
    }
}
