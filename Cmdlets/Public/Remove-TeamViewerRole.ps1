function Remove-TeamViewerRole {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType([void])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerRoleId } )]
        [Alias('Role')]
        [Alias('Id')]
        [object]
        $RoleId
    )

    begin {
        $ResourceUri = "$(Get-TeamViewerApiUri)/userroles?userRoleId=$RoleId"
    }

    process {
        if ($PSCmdlet.ShouldProcess($RoleId.ToString(), 'Remove Role')) {
            Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $ResourceUri `
                -Method Delete `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop | `
                Out-Null
        }
    }
}
