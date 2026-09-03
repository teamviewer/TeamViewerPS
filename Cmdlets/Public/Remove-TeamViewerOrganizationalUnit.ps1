function Remove-TeamViewerOrganizationalUnit {
    [CmdletBinding(SupportsShouldProcess = $true)]

    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias('Token')]
        [securestring]
        $ApiToken,

        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        [ValidateScript({ $_ | Resolve-TeamViewerOrganizationalUnitId })]
        [Alias('Id', 'OrganizationalUnitId')]
        [object]
        $OrganizationalUnit
    )

    process {
        $OrganizationalUnitId = $OrganizationalUnit | Resolve-TeamViewerOrganizationalUnitId
        $Uri = "$(Get-TeamViewerApiUri)/organizationalunits/$OrganizationalUnitId"

        if ($PSCmdlet.ShouldProcess($OrganizationalUnitId, 'Remove organizational unit')) {
            Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $Uri `
                -Method Delete `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop | Out-Null
        }
    }
}
