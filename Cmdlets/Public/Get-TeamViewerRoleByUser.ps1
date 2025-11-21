function Get-TeamViewerRoleByUser {
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
        $parameters = $null
        $list = @()
    }
    process {
        $resourceUri = $copyUri
        do {
            $response = Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $resourceUri `
                -Method Get `
                -Body $parameters `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop

            if ($response.assignedRoleIds -and $response.assignedRoleIds.Count -gt 0) {
                $list += $response.assignedRoleIds
            }
            if ($response.nextPaginationToken) {
                $resourceUri = $copyUri + '?paginationToken=' + $response.nextPaginationToken
            }
        } while ($response.nextPaginationToken)
        return $list
    }
}
