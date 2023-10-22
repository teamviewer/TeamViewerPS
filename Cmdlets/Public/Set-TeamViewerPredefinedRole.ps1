function Set-TeamViewerPredefinedRole {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true )]
        [ValidateScript({ $_ | Resolve-TeamViewerRoleId })]
        [object]
        $RoleId
    )

    Process {
        $Role = $RoleId | Resolve-TeamViewerRoleId
        $resourceUri = "$(Get-TeamViewerApiUri)/userroles/$Role/predefined"
        if ($PSCmdlet.ShouldProcess($Role, 'Set Predefined Role')) {
            Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $resourceUri `
                -Method Put `
                -ContentType 'application/json; charset=utf-8' `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop | `
                Out-Null
        }
    }

}
