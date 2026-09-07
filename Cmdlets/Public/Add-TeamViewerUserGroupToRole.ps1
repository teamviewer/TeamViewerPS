function Add-TeamViewerUserGroupToRole {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType([pscustomobject])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerRoleId } )]
        [Alias('Id', 'RoleId')]
        [object]
        $Role,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerUserGroupId } )]
        [Alias('UserGroupId')]
        [object]
        $UserGroup
    )

    begin {
        $Role_Id = $Role | Resolve-TeamViewerRoleId

        $null = $APIToken # https://github.com/PowerShell/PSScriptAnalyzer/issues/1472
        $Resource_Uri = "$(Get-TeamViewerAPIUri)/userroles/assign/usergroup"
        $Body = @{
            UserRoleId  = $Role_Id
            UserGroupId = $UserGroup

        }
    }

    process {
        if ($PSCmdlet.ShouldProcess($UserGroup, 'Add user group to role')) {
            $Result = Invoke-TeamViewerRestMethod `
                -APIToken $APIToken `
                -Uri $Resource_Uri `
                -Method Post `
                -ContentType 'application/json; charset=utf-8' `
                -Body ([System.Text.Encoding]::UTF8.GetBytes(($Body | ConvertTo-Json))) `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop

            Write-Output ($Result)
        }
    }
}
