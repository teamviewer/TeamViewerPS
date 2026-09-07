function Set-TeamViewerDefaultRole {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType([void])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true )]
        [ValidateScript({ $_ | Resolve-TeamViewerRoleId })]
        [Alias('Id', 'Role')]
        [object]
        $RoleId
    )

    process {
        $Role = $RoleId | Resolve-TeamViewerRoleId
        $Resource_Uri = "$(Get-TeamViewerAPIUri)/userroles/$Role/predefined"

        if ($PSCmdlet.ShouldProcess($Role, 'Set Default Role')) {
            Invoke-TeamViewerRestMethod `
                -APIToken $APIToken `
                -Uri $Resource_Uri `
                -Method Put `
                -ContentType 'application/json; charset=utf-8' `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop | `
                Out-Null
        }
    }

}
