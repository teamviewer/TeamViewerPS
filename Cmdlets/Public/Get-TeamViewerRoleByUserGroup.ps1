function Get-TeamViewerRoleByUserGroup {
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript({ $_ | Resolve-TeamViewerUserGroupId })]
        [Alias('UserGroupId')]
        [string]
        $GroupId
    )

    Begin {
        $resourceUri = "$(Get-TeamViewerApiUri)/usergroups/$GroupId/userroles"
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
            Write-Output ($response.assignedRoleId | ConvertTo-TeamViewerRoleAssignedUserGroup )
        }while ($response.ContinuationToken)
    }
}
