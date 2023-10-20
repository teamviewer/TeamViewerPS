function Remove-TeamViewerRole {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerRoleId } )]
        [Alias('UserRole')]
        [Alias('Id')]
        [object]
        $RoleId
    )

    Begin {
        $resourceUri = "$(Get-TeamViewerApiUri)/userroles?userRoleId=$RoleId"
    }

    Process {
        if ($PSCmdlet.ShouldProcess($RoleId.ToString(), 'Remove Role')) {
            Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $resourceUri `
                -Method Delete `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop | `
                Out-Null
        }
    }
}
