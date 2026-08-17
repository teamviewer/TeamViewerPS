function Get-TeamViewerUserGroup {
    [CmdletBinding()]

    [OutputType('TeamViewerPS.UserGroup')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter()]
        [ValidateScript( { $_ | Resolve-TeamViewerUserGroupId } )]
        [Alias('UserGroupId')]
        [Alias('Id')]
        [object]
        $UserGroup
    )

    begin {
        $resourceUri = "$(Get-TeamViewerApiUri)/usergroups"
        $parameters = @{ }
        $isListOperation = $true

        if ($UserGroup) {
            $GroupId = $UserGroup | Resolve-TeamViewerUserGroupId
            $resourceUri += "/$GroupId"
            $parameters = $null
            $isListOperation = $false
        }
    }

    process {
        do {
            $response = Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $resourceUri `
                -Method Get `
                -Body $parameters `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop

            if ($UserGroup) {
                Write-Output ($response | ConvertTo-TeamViewerUserGroup)
            }
            else {
                $parameters.paginationToken = $response.nextPaginationToken
                Write-Output ($response.resources | ConvertTo-TeamViewerUserGroup)
            }
        } while ($isListOperation -and $parameters.paginationToken)
    }
}
