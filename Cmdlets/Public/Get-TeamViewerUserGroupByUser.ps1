function Get-TeamViewerUserGroupByUser {
    [CmdletBinding()]

    [OutputType('TeamViewerPS.UserGroup')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript({ $_ | Resolve-TeamViewerUserId })]
        [Alias('Id', 'UserId')]
        [object]
        $User
    )

    begin {
        $User_Id = $User | Resolve-TeamViewerUserId
        $Resource_Uri = "$(Get-TeamViewerAPIUri)/users/$User_Id/usergroups"
    }

    process {
        $Resource_UriPage = $Resource_Uri

        do {
            $Response = Invoke-TeamViewerRestMethod `
                -APIToken $APIToken `
                -Uri $Resource_UriPage `
                -Method Get `
                -Body $null `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop

            if ($Response.resources) {
                Write-Output ($Response.resources | ConvertTo-TeamViewerUserGroup)
            }

            if ($Response.nextPaginationToken) {
                $Resource_UriPage = Get-TeamViewerPaginationUri `
                    -Uri $Resource_Uri `
                    -ParameterName 'paginationToken' `
                    -Token $Response.nextPaginationToken
            }
        } while ($Response.nextPaginationToken)
    }
}
