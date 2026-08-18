function Add-TeamViewerUserGroupToRole {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType([pscustomobject])]

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

    begin {
        $RoleId = $Role | Resolve-TeamViewerRoleId
        $null = $ApiToken
        $ResourceUri = "$(Get-TeamViewerApiUri)/userroles/assign/usergroup"
        $Body = @{
            UserRoleId  = $RoleId
            UserGroupId = $UserGroup

        }
    }


    process {
        if ($PSCmdlet.ShouldProcess($UserGroup, 'Assign Role to User Group')) {
            $Result = Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $ResourceUri `
                -Method Post `
                -ContentType 'application/json; charset=utf-8' `
                -Body ([System.Text.Encoding]::UTF8.GetBytes(($Body | ConvertTo-Json))) `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop

            Write-Output ($Result)
        }
    }
}
