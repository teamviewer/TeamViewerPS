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
                [Alias('ParentId')]
                [string]
                $Parent,

                [Parameter( Mandatory = $false, ParameterSetName = 'List')]
                [ValidateLength(1, [int]::MaxValue)]
                [string]
                $Filter,

                [Parameter( Mandatory = $false, ParameterSetName = 'List')]
                [ValidateSet('Name', 'CreatedAt', 'UpdatedAt')]
                [Alias('Sort')]
                [string]
                $SortBy = 'Name',

                [Parameter( Mandatory = $false, ParameterSetName = 'List')]
                [ValidateSet('Asc', 'Desc')]
                [Alias('Order')]
                [string]
                $SortOrder = 'Asc',

                [Parameter( Mandatory = $false, ParameterSetName = 'List')]
                [ValidateRange(50, 250)]
                [int]
                $PageSize = 100,

                [Parameter( Mandatory = $false, ParameterSetName = 'List')]
                [ValidateRange(1, [int]::MaxValue)]
                [int]
                $PageNumber = 1
        )

        process {
                $Uri = "$(Get-TeamViewerApiUri)/organizationalunits"
                $Body = @{}

                switch ($PSCmdlet.ParameterSetName) {
                        'ById' {
                                $OrganizationalUnitId = $OrganizationalUnit | Resolve-TeamViewerOrganizationalUnitId
                                $Uri += "/$OrganizationalUnitId"
                                $Body = $null
                        }
                        'List' {
                                if ($Recursive) {
                                        $Body.includeChildren = $true
                                }
                                if ($Parent) {
                                        $Body.startOrganizationalUnitId = $Parent
                                }
                                if ($Filter) {
                                        $Body.filter = $Filter
                                }

                                $Body.sortBy = $SortBy
                                $Body.sortOrder = $SortOrder
                                $Body.pageSize = $PageSize
                                $Body.pageNumber = $PageNumber
                        }
                }

                $Response = Invoke-TeamViewerRestMethod `
                        -ApiToken $ApiToken `
                        -Uri $Uri `
                        -Method Get `
                        -Body $Body `
                        -WriteErrorTo $PSCmdlet `
                        -ErrorAction Stop

                if ($PSCmdlet.ParameterSetName -eq 'ById') {
                        $Response | ConvertTo-TeamViewerOrganizationalUnit
                }
                else {
                        $Response.data | ConvertTo-TeamViewerOrganizationalUnit
                }
        }
}
