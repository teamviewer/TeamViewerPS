function Get-TeamViewerUserGroupByRole {
    [CmdletBinding()]

    [OutputType('TeamViewerPS.RoleAssignedUserGroup')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript({ $_ | Resolve-TeamViewerRoleId })]
        [Alias('Role')]
        [string]
        $RoleId
    )

    begin {
        $ResourceUri = "$(Get-TeamViewerApiUri)/userroles/assignments/usergroups?userRoleId=$RoleId"
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

            Write-Output ($Response.AssignedToGroups | ConvertTo-TeamViewerRoleAssignedUserGroup )
        } while ($Response.ContinuationToken)
    }
}
