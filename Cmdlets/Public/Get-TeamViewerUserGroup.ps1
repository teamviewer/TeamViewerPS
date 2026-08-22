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
        $ResourceUri = "$(Get-TeamViewerApiUri)/usergroups"
        $Parameters = @{ }
        $IsListOperation = $true

        if ($UserGroup) {
            $GroupId = $UserGroup | Resolve-TeamViewerUserGroupId
            $ResourceUri += "/$GroupId"
            $Parameters = $null
            $IsListOperation = $false
        }
    }

    process {
        do {
            $Response = Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $ResourceUri `
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
