function Add-TeamViewerRoleToUserGroup {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerUserRoleId } )]
        [Alias('UserRoleId')]
        [object]
        $UserRole,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerUserGroupId } )]
        [Alias('UserGroupId')]
        [Alias('Id')]
        [object]
        $UserGroup
    )

    Begin {
        $RoleId = $UserRole | Resolve-TeamViewerUserRoleId
        $null = $ApiToken
        $resourceUri = "$(Get-TeamViewerApiUri)/userroles/assign/usergroup"
        $body = @{
            UserRoleId  = $RoleId
            UserGroupId = $UserGroup

        }
    }


    Process {
        if ($PSCmdlet.ShouldProcess($UserGroup, 'Assign Role to User Group')) {
            $result = Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $resourceUri `
                -Method Post `
                -ContentType 'application/json; charset=utf-8' `
                -Body ([System.Text.Encoding]::UTF8.GetBytes(($body | ConvertTo-Json))) `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop
            Write-Output ($result)
        }
    }
}
