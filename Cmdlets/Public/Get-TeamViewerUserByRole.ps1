function Get-TeamViewerUserByRole {
    [CmdletBinding()]

    [OutputType('TeamViewerPS.RoleUserMembership')]

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
        $Resource_Uri = "$(Get-TeamViewerAPIUri)/userroles/assignments/account?userRoleId=$Role"
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
                $Resource_UriPage = Get-TeamViewerPaginationUri `
                    -Uri $Resource_Uri `
                    -ParameterName 'continuationToken' `
                    -Token $Response.ContinuationToken
            }

            Write-Output ($Response.AssignedToUsers | ConvertTo-TeamViewerRoleUserMembership )
        } while ($Response.ContinuationToken)
    }
}
