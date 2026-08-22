function Get-TeamViewerRoleByUserGroup {
    [CmdletBinding()]

    [OutputType('TeamViewerPS.UserGroupAssignedRole')]

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
        $ResourceUri = "$(Get-TeamViewerApiUri)/usergroups/$GroupId/userroles"
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
