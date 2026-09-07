function Get-TeamViewerRoleByUserGroup {
    [CmdletBinding()]

    [OutputType('TeamViewerPS.RoleAssignedUserGroup')]

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
        $ResourceUri = "$(Get-TeamViewerAPIUri)/usergroups/$UserGroup/userroles"
        $Parameters = $null
    }

    process {
        do {
            $Response = Invoke-TeamViewerRestMethod `
                -APIToken $APIToken `
                -Uri $ResourceUri `
                -Method Get `
                -Body $Parameters `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop

            if ($Response.ContinuationToken) {
                $ResourceUri += '&continuationToken=' + $Response.ContinuationToken
            }

            if ($null -eq $Response.assignedRoleId) {
                break
            }

            Write-Output ($Response.assignedRoleId | ConvertTo-TeamViewerRoleAssignedUserGroup )
        }while ($Response.ContinuationToken)
    }
}
