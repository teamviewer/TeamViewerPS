function Get-TeamViewerConditionalAccessRule {
    [CmdletBinding()]

    [OutputType('TeamViewerPS.ConditionalAccessRule')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken
    )

    $Resource_Uri = "$(Get-TeamViewerAPIUri)/ConditionalAccess/Rules"
    $Resource_UriPage = $Resource_Uri

    do {
        $Response = Invoke-TeamViewerRestMethod `
            -APIToken $APIToken `
            -Uri $Resource_UriPage `
            -Method Get `
            -WriteErrorTo $PSCmdlet `
            -ErrorAction Stop

        Write-Output ($Response.rules | ConvertTo-TeamViewerConditionalAccessRule)

        if ($Response.continuation_token) {
            $Resource_UriPage = Get-TeamViewerPaginationUri `
                -Uri $Resource_Uri `
                -ParameterName 'continuation_token' `
                -Token $Response.continuation_token
        }
    } while ($Response.continuation_token)
}
