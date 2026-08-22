function Get-TeamViewerRoleByUser {
    [CmdletBinding()]

    [OutputType([guid[]])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript({ $_ | Resolve-TeamViewerUserId })]
        [Alias('UsersId')]
        [Alias('Id')]
        [string]
        $UserId
    )

    begin {
        $copyUri = "$(Get-TeamViewerApiUri)/users/$userId/userroles"
        $Parameters = $null
        $list = @()
    }

    process {
        $ResourceUri = $copyUri

        do {
            $Response = Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $ResourceUri `
                -Method Get `
                -Body $Parameters `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop

            if ($Response.assignedRoleIds -and $Response.assignedRoleIds.Count -gt 0) {
                $list += $Response.assignedRoleIds
            }

            if ($Response.nextPaginationToken) {
                $ResourceUri = $copyUri + '?paginationToken=' + $Response.nextPaginationToken
            }
        } while ($Response.nextPaginationToken)

        Write-Output $list
    }
}
