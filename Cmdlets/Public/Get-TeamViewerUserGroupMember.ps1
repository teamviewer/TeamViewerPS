function Get-TeamViewerUserGroupMember {
    [CmdletBinding()]

    [OutputType('TeamViewerPS.UserGroupMember')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerUserGroupId } )]
        [Alias('Id', 'UserGroupId')]
        [object]
        $UserGroup
    )

    begin {
        $UserGroup_Id = $UserGroup | Resolve-TeamViewerUserGroupId

        $Resource_Uri = "$(Get-TeamViewerAPIUri)/usergroups/$UserGroup_Id/members"
        $Parameters = @{ }
    }

    process {
        do {
            $Response = Invoke-TeamViewerRestMethod `
                -APIToken $APIToken `
                -Uri $Resource_Uri `
                -Method Get `
                -Body $Parameters `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop
            $Parameters.paginationToken = $Response.nextPaginationToken

            Write-Output ($Response.resources | ConvertTo-TeamViewerUserGroupMember)
        } while ($Parameters.paginationToken)
    }
}
