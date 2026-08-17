function Get-TeamViewerUserGroupMember {
    [CmdletBinding()]

    [OutputType('TeamViewerPS.UserGroupMember')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerUserGroupId } )]
        [Alias('UserGroupId')]
        [Alias('Id')]
        [object]
        $UserGroup
    )

    begin {
        $id = $UserGroup | Resolve-TeamViewerUserGroupId
        $resourceUri = "$(Get-TeamViewerApiUri)/usergroups/$id/members"
        $parameters = @{ }
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
            $parameters.paginationToken = $response.nextPaginationToken
            Write-Output ($response.resources | ConvertTo-TeamViewerUserGroupMember)
        } while ($parameters.paginationToken)
    }
}
