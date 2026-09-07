function Get-TeamViewerRoleByUser {
    [CmdletBinding()]

    [OutputType([guid[]])]

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
        $ResourceUri_Copy = "$(Get-TeamViewerAPIUri)/users/$User/userroles"
        $Parameters = $null
        $list = @()
    }

    process {
        $ResourceUri = $ResourceUri_Copy

        do {
            $Response = Invoke-TeamViewerRestMethod `
                -APIToken $APIToken `
                -Uri $ResourceUri `
                -Method Get `
                -Body $Parameters `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop

            if ($Response.assignedRoleIds -and $Response.assignedRoleIds.Count -gt 0) {
                $list += $Response.assignedRoleIds
            }

            if ($Response.nextPaginationToken) {
                $ResourceUri = $ResourceUri_Copy + '?paginationToken=' + $Response.nextPaginationToken
            }
        } while ($Response.nextPaginationToken)

        Write-Output $list
    }
}
