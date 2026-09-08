function Get-TeamViewerConditionalAccessFeatureOption {
    [CmdletBinding()]

    [OutputType('TeamViewerPS.ConditionalAccessFeatureOption')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken
    )

    $Resource_Uri = "$(Get-TeamViewerAPIUri)/ConditionalAccess/Options/Features"
    $Resource_UriPage = $Resource_Uri

    do {
        $Response = Invoke-TeamViewerRestMethod `
            -APIToken $APIToken `
            -Uri $Resource_UriPage `
            -Method Get `
            -WriteErrorTo $PSCmdlet `
            -ErrorAction Stop

        Write-Output ($Response.options | ConvertTo-TeamViewerConditionalAccessFeatureOption)

        if ($Response.continuation_token) {
            $Resource_UriPage = Get-TeamViewerPaginationUri `
                -Uri $Resource_Uri `
                -ParameterName 'continuationToken' `
                -Token $Response.continuation_token
        }
    } while ($Response.continuation_token)
}
