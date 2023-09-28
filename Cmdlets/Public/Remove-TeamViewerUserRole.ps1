function Remove-TeamViewerUserRole {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerUserRoleId } )]
        [Alias('UserRole')]
        [Alias('Id')]
        [object]
        $UserRoleId
    )

    Begin {
        $resourceUri = "$(Get-TeamViewerApiUri)/userroles?userRoleId=$UserRoleId"
    }

    Process {
        if ($PSCmdlet.ShouldProcess($UserRoleId.ToString(), 'Remove User Role')) {
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
