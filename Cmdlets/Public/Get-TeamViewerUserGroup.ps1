function Get-TeamViewerUserGroup {
    [CmdletBinding()]

    [OutputType('TeamViewerPS.UserGroup')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken,

        [Parameter()]
        [ValidateScript( { $_ | Resolve-TeamViewerUserGroupId } )]
        [Alias('Id', 'UserGroupId')]
        [object]
        $UserGroup
    )

    begin {
        $Resource_Uri = "$(Get-TeamViewerAPIUri)/usergroups"
        $Parameters = @{ }
        $IsListOperation = $true

        if ($UserGroup) {
            $GroupId = $UserGroup | Resolve-TeamViewerUserGroupId
            $Resource_Uri += "/$GroupId"
            $Parameters = $null
            $IsListOperation = $false
        }
    }

    process {
        do {
            $Response = Invoke-TeamViewerRestMethod `
                -APIToken $APIToken `
                -Uri $Resource_Uri `
                -Method Get `
                -Body $Parameters `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop

            if ($UserGroup) {
                Write-Output ($Response | ConvertTo-TeamViewerUserGroup)
            }
            else {
                $Parameters.paginationToken = $Response.nextPaginationToken
                Write-Output ($Response.resources | ConvertTo-TeamViewerUserGroup)
            }
        } while ($IsListOperation -and $Parameters.paginationToken)
    }
}
