function Get-TeamViewerUserGroupByRole {
    [CmdletBinding()]

    [OutputType('TeamViewerPS.RoleAssignedUserGroup')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript({ $_ | Resolve-TeamViewerRoleId })]
        [Alias('Id', 'RoleId')]
        [string]
        $Role
    )

    begin {
        $ResourceUri = "$(Get-TeamViewerApiUri)/userroles/assignments/usergroups?userRoleId=$Role"
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
