function Get-TeamViewerRoleByUserGroup {
    [CmdletBinding()]

    [OutputType('TeamViewerPS.RoleAssignedUserGroup')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript({ $_ | Resolve-TeamViewerUserGroupId })]
        [Alias('Id', 'UserGroupId')]
        [string]
        $UserGroup
    )

    begin {
        $ResourceUri = "$(Get-TeamViewerApiUri)/usergroups/$UserGroup/userroles"
        $Parameters = $null
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
