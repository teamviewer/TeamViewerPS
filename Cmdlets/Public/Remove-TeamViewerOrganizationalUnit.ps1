function Remove-TeamViewerOrganizationalUnit {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerOrganizationalUnitId } )]
        [Alias('OrganizationalUnitId')]
        [Alias('Id')]
        [object]
        $OrganizationalUnit
    )

    Begin {
        $id = $OrganizationalUnit | Resolve-TeamViewerOrganizationalUnitId
        $resourceUri = "$(Get-TeamViewerApiUri)/organizationalunits/$id"
    }

    Process {
        if ($PSCmdlet.ShouldProcess($OrganizationalUnit.ToString(), 'Remove organizational unit')) {
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
