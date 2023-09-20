
function Set-TeamViewerUserRole {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true )]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [Alias('UserRoleName')]
        [string]
        $Name,

        [Parameter(Mandatory = $false)]
        [AllowEmptyCollection()]
        [object[]]
        $Permissions,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerUserRoleId } )]
        [Alias('UserRole')]
        [object]
        $UserRoleId
    )
    Begin {
        $resourceUri = "$(Get-TeamViewerApiUri)/userroles"
        $body = @{
            Name        = $Name
            Permissions = @()
            UserRoleId  = $UserRoleId

        }
        if ($Permissions) {
            $body.Permissions = @($Permissions)
        }
    }
    Process {
        if ($PSCmdlet.ShouldProcess($Name, 'Update User Role')) {
            $response = Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $resourceUri `
                -Method Put `
                -ContentType 'application/json; charset=utf-8' `
                -Body ([System.Text.Encoding]::UTF8.GetBytes(($body | ConvertTo-Json))) `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop

            $result = $response
            Write-Output $result
        }
    }

}
