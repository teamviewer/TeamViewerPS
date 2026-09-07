function Get-TeamViewerUserGroupByRole {
    [CmdletBinding()]

    [OutputType('TeamViewerPS.RoleUserGroupMembership')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript({ $_ | Resolve-TeamViewerRoleId })]
        [Alias('Id', 'RoleId')]
        [string]
        $Role
    )

    begin {
        $Resource_Uri = "$(Get-TeamViewerAPIUri)/userroles/assignments/usergroups?userRoleId=$Role"
        $Parameters = $null
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

            if ($Response.ContinuationToken) {
                $Resource_Uri += '&continuationToken=' + $Response.ContinuationToken
            }

            Write-Output ($Response.AssignedToGroups | ConvertTo-TeamViewerRoleUserGroupMembership )
        } while ($Response.ContinuationToken)
    }
}
