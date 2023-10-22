function Add-TeamViewerUserGroupToRole {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerRoleId } )]
        [Alias('RoleId')]
        [object]
        $Role,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerUserGroupId } )]
        [Alias('UserGroupId')]
        [Alias('Id')]
        [object]
        $UserGroup
    )

    Begin {
        $RoleId = $Role | Resolve-TeamViewerRoleId
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
