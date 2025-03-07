function New-TeamViewerOrganizationalUnit {
    [CmdletBinding(SupportsShouldProcess = $true)]

    param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias('Token')]
        [securestring]
        $ApiToken,

        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        [ValidateLength(1, 100)]
        [string]
        $Name,

        [Parameter(ValueFromPipeline = $true, Mandatory = $false)]
        [ValidateLength(1, 300)]
        [string]
        $Description,

        [Parameter(ValueFromPipeline = $true, Mandatory = $false)]
        [ValidateScript({ $_ -match '(?im)^[{(]?[0-9A-F]{8}[-]?(?:[0-9A-F]{4}[-]?){3}[0-9A-F]{12}[)}]?$' })]
        [string]
        $ParentId
    )

    Begin {
        # Construct the API base URI
        $Uri = "$(Get-TeamViewerApiUri)/organizationalunits"

        # Append parameters to request body
        $Body = @{ name = $Name }

        if ($Description) {
            $Body.description = $Description
        }
        if ($ParentId) {
            $Body.parentId = $ParentId
        }
    }

    Process {
        if ($PSCmdlet.ShouldProcess($Name, 'Create organizational unit')) {
            try {
                # Execute request
                $Response = Invoke-TeamViewerRestMethod `
                    -ApiToken $ApiToken `
                    -Uri $Uri `
                    -Method Post `
                    -ContentType 'application/json; charset=utf-8' `
                    -Body ([System.Text.Encoding]::UTF8.GetBytes(($Body | ConvertTo-Json))) `
                    -WriteErrorTo $PSCmdlet `
                    -ErrorAction Stop

                # Convert and output the response
                Write-Output ($Response | ConvertTo-TeamViewerOrganizationalUnit)
            }
            catch {
                # Handle any errors that occur
                Write-Error "Failed to create organizational unit: $_"
            }
        }
    }
}
