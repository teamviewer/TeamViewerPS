function Get-TeamViewerRoleByUserGroup {
    [CmdletBinding()]

    [OutputType('TeamViewerPS.UserGroupRoleMembership')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript({ $_ | Resolve-TeamViewerUserGroupId })]
        [Alias('Id', 'UserGroupId')]
        [string]
        $UserGroup
    )

    begin {
        $Resource_Uri = "$(Get-TeamViewerAPIUri)/usergroups/$UserGroup/userroles"
        $Parameters = $null
    }

    process {
        $Resource_UriPage = $Resource_Uri

        do {
            $Response = Invoke-TeamViewerRestMethod `
                -APIToken $APIToken `
                -Uri $Resource_UriPage `
                -Method Get `
                -Body $Parameters `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop

            if ($Response.ContinuationToken) {
                $Resource_UriPage = $Resource_Uri + '?continuationToken=' + $Response.ContinuationToken
            }

            if ($null -eq $Response.assignedRoleId) {
                break
            }

            Write-Output ($Response.assignedRoleId | ConvertTo-TeamViewerUserGroupRoleMembership )
        } while ($Response.ContinuationToken)
    }
}
