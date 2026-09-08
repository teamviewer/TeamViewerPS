function Get-TeamViewerConditionalAccessApprovalOption {
    [CmdletBinding()]

    [OutputType('TeamViewerPS.ConditionalAccessApprovalOption')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken
    )

    $Resource_Uri = "$(Get-TeamViewerAPIUri)/ConditionalAccess/Options/Approval"
    $Resource_UriPage = $Resource_Uri

    do {
        $Response = Invoke-TeamViewerRestMethod `
            -APIToken $APIToken `
            -Uri $Resource_UriPage `
            -Method Get `
            -WriteErrorTo $PSCmdlet `
            -ErrorAction Stop

        Write-Output ($Response.options | ConvertTo-TeamViewerConditionalAccessApprovalOption)

        if ($Response.continuation_token) {
            $Resource_UriPage = Get-TeamViewerPaginationUri `
                -Uri $Resource_Uri `
                -ParameterName 'continuationToken' `
                -Token $Response.continuation_token
        }
    } while ($Response.continuation_token)
}
