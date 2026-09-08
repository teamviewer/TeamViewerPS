function Get-TeamViewerPaginationUri {
    [CmdletBinding()]

    [OutputType([string])]

    param(
        [Parameter(Mandatory = $true)]
        [string]
        $Uri,

        [Parameter(Mandatory = $true)]
        [string]
        $ParameterName,

        [Parameter(Mandatory = $true)]
        [string]
        $Token
    )

    $Separator = if ($Uri.Contains('?')) { '&' } else { '?' }
    $Token_Encoded = [uri]::EscapeDataString($Token)

    return "$Uri$Separator$ParameterName=$Token_Encoded"
}
