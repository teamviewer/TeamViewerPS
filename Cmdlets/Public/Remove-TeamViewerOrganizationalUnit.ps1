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
        [PSObject]
        $OrganizationalUnit
    )


    Process {
        # Append Organizational Unit Id to base URI
        $OrganizationalUnitId = $OrganizationalUnit | Resolve-TeamViewerOrganizationalUnitId
        $Uri = "$(Get-TeamViewerApiUri)/organizationalunits/$OrganizationalUnitId"
        if ($PSCmdlet.ShouldProcess($OrganizationalUnit.ToString(), 'Remove organizational unit')) {
            try {
                # Execute request
                Invoke-TeamViewerRestMethod `
                    -ApiToken $ApiToken `
                    -Uri $Uri `
                    -Method Delete `
                    -WriteErrorTo $PSCmdlet `
                    -ErrorAction Stop
            }
            catch {
                # Handle any errors that occur
                Write-Error "Failed to remove organizational unit: $_"
            }
        }
    }
}
