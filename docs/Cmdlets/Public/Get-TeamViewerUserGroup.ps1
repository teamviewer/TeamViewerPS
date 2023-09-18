function Get-TeamViewerUserGroup {
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter()]
        [ValidateScript( { $_ | Resolve-TeamViewerUserGroupId } )]
        [Alias("UserGroupId")]
        [Alias("Id")]
        [object]
        $UserGroup
    )

    Begin {
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

    Process {
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
        } while ($isListOperation -And $parameters.paginationToken)
    }
}
