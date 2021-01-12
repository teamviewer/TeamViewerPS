function Get-TeamViewerManagedGroup {
    [CmdletBinding(DefaultParameterSetName = "List")]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(ParameterSetName = "ByGroupId")]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedGroupId } ) ]
        [Alias("GroupId")]
        [guid]
        $Id
    )

    $resourceUri = "$(Get-TeamViewerApiUri)/managed/groups";
    $parameters = @{ }

    switch ($PsCmdlet.ParameterSetName) {
        'ByGroupId' {
            $resourceUri += "/$Id"
            $parameters = $null
        }
    }

    do {
        $response = Invoke-TeamViewerRestMethod `
            -ApiToken $ApiToken `
            -Uri $resourceUri `
            -Method Get `
            -Body $parameters `
            -WriteErrorTo $PSCmdlet `
            -ErrorAction Stop

        if ($PsCmdlet.ParameterSetName -Eq 'ByGroupId') {
            Write-Output ($response | ConvertTo-TeamViewerManagedGroup)
        }
        else {
            $parameters.paginationToken = $response.nextPaginationToken
            Write-Output ($response.resources | ConvertTo-TeamViewerManagedGroup)
        }
    } while ($PsCmdlet.ParameterSetName -Eq 'List' -And $parameters.paginationToken)
}
