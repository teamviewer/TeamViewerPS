function Get-TeamViewerRoleByUser {
    [CmdletBinding()]

    [OutputType('TeamViewerPS.UserRoleMembership')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript({ $_ | Resolve-TeamViewerUserId })]
        [Alias('Id', 'UserId')]
        [string]
        $User
    )

    begin {
        $Resource_Uri = "$(Get-TeamViewerAPIUri)/users/$User/userroles"
        $Parameters = $null
        $list = @()
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

            if ($Response.assignedRoleIds -and $Response.assignedRoleIds.Count -gt 0) {
                $list += $Response.assignedRoleIds
            }

            if ($Response.nextPaginationToken) {
                $Resource_UriPage = Get-TeamViewerPaginationUri `
                    -Uri $Resource_Uri `
                    -ParameterName 'paginationToken' `
                    -Token $Response.nextPaginationToken
            }
        } while ($Response.nextPaginationToken)

        if ($list.Count -gt 0) {
            Write-Output ($list | ConvertTo-TeamViewerUserRoleMembership)
        }
    }
}
