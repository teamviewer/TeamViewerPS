function Get-TeamViewerRoleByUserGroup {
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript({ $_ | Resolve-TeamViewerUserGroupId })]
        [Alias('UserGroupId')]
        [Alias('Id')]
        [string]
        $GroupId
    )

    begin {
        $resourceUri = "$(Get-TeamViewerApiUri)/usergroups/$GroupId/userroles"
        $parameters = $null
    }

    process {
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

            if ($null -eq $response.assignedRoleId) {
                break
            }

            Write-Output ($response.assignedRoleId | ConvertTo-TeamViewerRoleAssignedUserGroup )
        }while ($response.ContinuationToken)
    }
}
