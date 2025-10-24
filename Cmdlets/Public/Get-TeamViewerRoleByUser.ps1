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

    Begin {
        $resourceUri = "$(Get-TeamViewerApiUri)/users/$userId/userroles"
        $parameters = $null
    }
    Process {
        do {
            $response = Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $resourceUri `
                -Method Get `
                -Body $parameters `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop
            if ($response.ContinuationToken) {
                $resourceUri += '&continuationToken=' + $response.ContinuationToken
            }
            if ($null -eq $response.assignedRoleId) {
                return $null
            }
            Write-Output ($response.assignedRoleId | ConvertTo-TeamViewerRoleAssignedUser )
        }while ($response.ContinuationToken)
    }
}
