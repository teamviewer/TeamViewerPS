function Set-TeamViewerPredefinedRole {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType([void])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true )]
        [ValidateScript({ $_ | Resolve-TeamViewerRoleId })]
        [object]
        $RoleId
    )

    process {
        $Role = $RoleId | Resolve-TeamViewerRoleId
        $ResourceUri = "$(Get-TeamViewerApiUri)/userroles/$Role/predefined"

        if ($PSCmdlet.ShouldProcess($Role, 'Set Predefined Role')) {
            Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $ResourceUri `
                -Method Put `
                -ContentType 'application/json; charset=utf-8' `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop | `
                Out-Null
        }
    }

}
