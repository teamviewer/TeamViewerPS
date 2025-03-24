function Get-TeamViewerOrganizationalUnit {
        [CmdletBinding(DefaultParameterSetName = 'List')]

        param(
                [Parameter(Mandatory = $true)]
                [ValidateNotNullOrEmpty()]
                [Alias('Token')]
                [securestring]
                $ApiToken,

                [Parameter(ValueFromPipeline = $true, Mandatory = $true, ParameterSetName = 'ById')]
                [ValidateScript({ $_ | Resolve-TeamViewerOrganizationalUnitId })]
                [Alias('Id', 'OrganizationalUnitId')]
                [object]
                $OrganizationalUnit,

                [Parameter( Mandatory = $false, ParameterSetName = 'List')]
                [Alias('IncludeChildren')]
                [Switch]
                $Recursive,

                [Parameter( Mandatory = $false, ParameterSetName = 'List')]
                [ValidateScript({ $_ -match '(?im)^[{(]?[0-9A-F]{8}[-]?(?:[0-9A-F]{4}[-]?){3}[0-9A-F]{12}[)}]?$' })]
                [Alias('StartOrganizationalUnitId')]
                [string]
                $ParentId,

                [Parameter( Mandatory = $false, ParameterSetName = 'List')]
                [ValidateLength(1, [int]::MaxValue)]  # Minimum length 1
                [string]
                $Filter,

                [Parameter( Mandatory = $false, ParameterSetName = 'List')]
                [ValidateSet('Name', 'CreatedAt', 'UpdatedAt')]
                [string]
                $SortBy = 'Name',

                [Parameter( Mandatory = $false, ParameterSetName = 'List')]
                [ValidateSet('Asc', 'Desc')]
                [string]
                $SortOrder = 'Asc',

                [Parameter( Mandatory = $false, ParameterSetName = 'List')]
                [ValidateRange(50, 250)]
                [int]
                $PageSize = 100,

                [Parameter( Mandatory = $false, ParameterSetName = 'List')]
                [ValidateRange(1)]
                [int]
                $PageNumber = 1
        )

        Begin {
                # Construct the API base URI
                $Body = @{}
                $Uri = "$(Get-TeamViewerApiUri)/organizationalunits"
        }

        Process {

                if ($PSCmdlet.ParameterSetName -eq 'ById') {
                        # Append Organizational Unit Id to base URI
                        $OrganizationalUnitId = $OrganizationalUnit | Resolve-TeamViewerOrganizationalUnitId
                        $Uri = "$(Get-TeamViewerApiUri)/organizationalunits/$OrganizationalUnitId"
                        $Body = $null
                }
                else {
                        # Append parameters to request body
                        if ($Recursive) {
                                $Body.includeChildren = $true
                        }
                        if ($ParentId) {
                                $Body.startOrganizationalUnitId = $ParentId
                        }
                        if ($Filter) {
                                $Body.filter = $Filter
                        }
                        if ($SortBy) {
                                $Body.sortBy = $SortBy
                        }
                        if ($SortOrder) {
                                $Body.sortOrder = $SortOrder
                        }
                        if ($PageSize) {
                                $Body.pageSize = $PageSize
                        }
                        if ($PageNumber) {
                                $Body.pageNumber = $PageNumber
                        }
                }

                try {
                        # Execute request
                        $Response = Invoke-TeamViewerRestMethod `
                                -ApiToken $ApiToken `
                                -Uri $Uri `
                                -Method Get `
                                -Body $Body `
                                -WriteErrorTo $PSCmdlet `
                                -ErrorAction Stop

                        # Convert and output the response
                        if ($PSCmdlet.ParameterSetName -eq 'ById') {
                                Write-Output ($Response | ConvertTo-TeamViewerOrganizationalUnit)
                        }
                        Else {
                                Write-Output ($Response.data | ConvertTo-TeamViewerOrganizationalUnit)
                        }
                }
                catch {
                        # Handle errors
                        Write-Error "Failed to get organizational unit: $_"
                }
        }
}
