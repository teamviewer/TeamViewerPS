function Set-TeamViewerUserGroup {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType('TeamViewerPS.UserGroup')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerUserGroupId } )]
        [Alias('UserGroupId')]
        [Alias('Id')]
        [object]
        $UserGroup,

        [Parameter(Mandatory = $true)]
        [Alias('UserGroupName')]
        [string]
        $Name
    )

    begin {
        $id = $UserGroup | Resolve-TeamViewerUserGroupId
        $resourceUri = "$(Get-TeamViewerApiUri)/usergroups/$id"
        $body = @{ name = $Name }
    }

    process {
        if ($PSCmdlet.ShouldProcess($UserGroup.ToString(), 'Change user group')) {
            $response = Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $resourceUri `
                -Method Put `
                -ContentType 'application/json; charset=utf-8' `
                -Body ([System.Text.Encoding]::UTF8.GetBytes(($body | ConvertTo-Json))) `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop

            Write-Output ($response | ConvertTo-TeamViewerUserGroup)
        }
    }
}
