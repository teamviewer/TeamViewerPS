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
        $Resource_Uri_Copy = "$(Get-TeamViewerAPIUri)/users/$User/userroles"
        $Parameters = $null
        $list = @()
    }

    process {
        $Resource_Uri = $Resource_Uri_Copy

        do {
            $Response = Invoke-TeamViewerRestMethod `
                -APIToken $APIToken `
                -Uri $Resource_Uri `
                -Method Get `
                -Body $Parameters `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop

            if ($Response.assignedRoleIds -and $Response.assignedRoleIds.Count -gt 0) {
                $list += $Response.assignedRoleIds
            }

            if ($Response.nextPaginationToken) {
                $Resource_Uri = $Resource_Uri_Copy + '?paginationToken=' + $Response.nextPaginationToken
            }
        } while ($Response.nextPaginationToken)

        if ($list.Count -gt 0) {
            Write-Output ($list | ConvertTo-TeamViewerUserRoleMembership)
        }
    }
}
