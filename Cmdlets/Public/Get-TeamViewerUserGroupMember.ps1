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
        $Id = $UserGroup | Resolve-TeamViewerUserGroupId
        $ResourceUri = "$(Get-TeamViewerApiUri)/usergroups/$Id/members"
        $Parameters = @{ }
    }

    process {
        do {
            $Response = Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $ResourceUri `
                -Method Get `
                -Body $Parameters `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop
            $Parameters.paginationToken = $Response.nextPaginationToken

            Write-Output ($Response.resources | ConvertTo-TeamViewerUserGroupMember)
        } while ($Parameters.paginationToken)
    }
}
