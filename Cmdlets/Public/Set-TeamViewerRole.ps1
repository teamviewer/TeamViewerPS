
function Set-TeamViewerRole {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType([void])]

    param(
        [Parameter(Mandatory = $true )]
        [securestring]
        $APIToken,

        [Parameter(Mandatory = $true)]
        [string]
        $Name,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerRoleId } )]
        [Alias('Id', 'RoleId')]
        [object]
        $Role,

        [Parameter(Mandatory = $false)]
        [AllowEmptyCollection()]
        [object[]]
        $Permissions
    )

    begin {
        $Resource_Uri = "$(Get-TeamViewerAPIUri)/userroles"
        $RoleId = $Role | Resolve-TeamViewerRoleId
        $Body = @{
            Name        = $Name
            Permissions = @()
            UserRoleId  = $RoleId

        }

        if ($Permissions) {
            $Body.Permissions = @($Permissions)
        }
    }

    process {
        if ($PSCmdlet.ShouldProcess($Name, 'Update Role')) {
            Invoke-TeamViewerRestMethod `
                -APIToken $APIToken `
                -Uri $Resource_Uri `
                -Method Put `
                -ContentType 'application/json; charset=utf-8' `
                -Body ([System.Text.Encoding]::UTF8.GetBytes(($Body | ConvertTo-Json))) `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop | Out-Null
        }
    }
}
