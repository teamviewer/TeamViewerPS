function Remove-TeamViewerOrganizationalUnit {
    [CmdletBinding(SupportsShouldProcess = $true)]

    param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
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

    Begin {
        # Construct the API base URI
        $Uri = "$(Get-TeamViewerApiUri)/organizationalunits"

        # Append Organizational Unit Id to base URI
        $OrganizationalUnitId = $OrganizationalUnit | Resolve-TeamViewerOrganizationalUnitId
        $Uri += "/$OrganizationalUnitId"
    }

    Process {
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
