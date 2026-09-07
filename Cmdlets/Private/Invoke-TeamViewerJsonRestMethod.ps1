function Invoke-TeamViewerJsonRestMethod {
    <#
        Sends a JSON request to the TeamViewer API on behalf of a public cmdlet.
        It centralizes the shared plumbing used by the batch cmdlets: the JSON content type,
        UTF-8 encoding of the payload, and surfacing REST errors to the calling cmdlet.
        The Body must be provided as an already-serialized JSON string.
    #>
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken,

        [Parameter(Mandatory = $true)]
        [uri]
        $Uri,

        [Parameter(Mandatory = $true)]
        [Microsoft.PowerShell.Commands.WebRequestMethod]
        $Method,

        [Parameter(Mandatory = $true)]
        [string]
        $Body,

        [System.Management.Automation.PSCmdlet]
        $CallerCmdlet
    )

    return Invoke-TeamViewerRestMethod `
        -APIToken $APIToken `
        -Uri $Uri `
        -Method $Method `
        -ContentType 'application/json; charset=utf-8' `
        -Body ([System.Text.Encoding]::UTF8.GetBytes($Body)) `
        -WriteErrorTo $CallerCmdlet `
        -ErrorAction Stop
}
