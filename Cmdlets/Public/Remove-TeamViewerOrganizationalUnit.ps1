function Remove-TeamViewerOrganizationalUnit {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerOrganizationalUnitId } )]
        [Alias('OrganizationalUnitId')]
        [Alias('Id')]
        [object]
        $OrganizationalUnit
    )
    Process {
        $OrganizationalUnitId = $OrganizationalUnit | Resolve-TeamViewerOrganizationalUnitId
        $resourceUri = "$(Get-TeamViewerApiUri)/organizationalunits/$OrganizationalUnitId"

        if ($PSCmdlet.ShouldProcess($OrganizationalUnitId, 'Remove organizational unit')) {
            Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $resourceUri `
                -Method Delete `
                -WriteErrorTo $PSCmdlet | `
                Out-Null
        }
    }
}
