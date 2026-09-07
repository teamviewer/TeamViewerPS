function Set-TeamViewerPredefinedRole {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType([void])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true )]
        [ValidateScript({ $_ | Resolve-TeamViewerRoleId })]
        [object]
        $RoleId
    )

    process {
        $Role = $RoleId | Resolve-TeamViewerRoleId
        $ResourceUri = "$(Get-TeamViewerAPIUri)/userroles/$Role/predefined"

        if ($PSCmdlet.ShouldProcess($Role, 'Set Predefined Role')) {
            Invoke-TeamViewerRestMethod `
                -APIToken $APIToken `
                -Uri $ResourceUri `
                -Method Put `
                -ContentType 'application/json; charset=utf-8' `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop | `
                Out-Null
        }
    }

}
