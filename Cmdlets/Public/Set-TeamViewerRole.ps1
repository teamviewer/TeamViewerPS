
function Set-TeamViewerRole {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType('TeamViewerPS.Role')]

    param(
        [Parameter(Mandatory = $true )]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [Alias('RoleName')]
        [string]
        $Name,

        [Parameter(Mandatory = $false)]
        [AllowEmptyCollection()]
        [object[]]
        $Permissions,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerRoleId } )]
        [Alias('Role')]
        [object]
        $RoleId
    )

    begin {
        $ResourceUri = "$(Get-TeamViewerApiUri)/userroles"
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
            $Response = Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $ResourceUri `
                -Method Put `
                -ContentType 'application/json; charset=utf-8' `
                -Body ([System.Text.Encoding]::UTF8.GetBytes(($Body | ConvertTo-Json))) `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop

            $Result = $Response

            Write-Output $Result
        }
    }

}
