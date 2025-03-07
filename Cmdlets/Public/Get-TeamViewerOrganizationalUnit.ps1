function Get-TeamViewerOrganizationalUnit {
    [CmdletBinding(DefaultParameterSetName = 'List')]

    param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias('Token')]
        [securestring]
        $ApiToken,

        [Parameter(ValueFromPipeline = $true, Mandatory = $true, ParameterSetName = 'ById')]
        [ValidateScript({ $_ | Resolve-TeamViewerOrganizationalUnitId })]
        [Alias('Id', 'OrganizationalUnitId')]
        [PSObject]
        $OrganizationalUnit,

        [Parameter(ValueFromPipeline = $true, Mandatory = $false, ParameterSetName = 'List')]
        [Alias('IncludeChildren')]
        [Switch]
        $Recursive,

        [Parameter(ValueFromPipeline = $true, Mandatory = $false, ParameterSetName = 'List')]
        [ValidateScript({ $_ -match '(?im)^[{(]?[0-9A-F]{8}[-]?(?:[0-9A-F]{4}[-]?){3}[0-9A-F]{12}[)}]?$' })]
        [Alias('StartOrganizationalUnitId')]
        [string]
        $ParentId,

        [Parameter(ValueFromPipeline = $true, Mandatory = $false, ParameterSetName = 'List')]
        [ValidateLength(1)]
        [string]
        $Filter,

        [Parameter(ValueFromPipeline = $true, Mandatory = $false, ParameterSetName = 'List')]
        [ValidateSet('Name', 'CreatedAt', 'UpdatedAt')]
        [string]
        $SortBy = 'Name',

        [Parameter(ValueFromPipeline = $true, Mandatory = $false, ParameterSetName = 'List')]
        [ValidateSet('Asc', 'Desc')]
        [string]
        $SortOrder = 'Asc',

        [Parameter(ValueFromPipeline = $true, Mandatory = $false, ParameterSetName = 'List')]
        [ValidateRange(50, 250)]
        [int]
        $PageSize = 100,

        [Parameter(ValueFromPipeline = $true, Mandatory = $false, ParameterSetName = 'List')]
        [ValidateRange(1)]
        [int]
        $PageNumber = 1
    )

    Begin {
        # Construct the API base URI
        $Uri = "$(Get-TeamViewerApiUri)/organizationalunits"
        $Body = @{}

        if ($PSCmdlet.ParameterSetName -eq 'ById') {
            # Append Organizational Unit Id to base URI
            $OrganizationalUnitId = $OrganizationalUnit | Resolve-TeamViewerOrganizationalUnitId
            $Uri += "/$OrganizationalUnitId"
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
    }

    Process {
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
            Write-Output ($Response | ConvertTo-TeamViewerOrganizationalUnit)
        }
        catch {
            # Handle errors
            Write-Error "Failed to get organizational unit: $_"
        }
    }
}
