function Remove-TeamViewerContact {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerContactId } )]
        [Alias("ContactId")]
        [Alias("Id")]
        [object]
        $Contact
    )
    Process {
        $contactId = $Contact | Resolve-TeamViewerContactId
        $resourceUri = "$(Get-TeamViewerApiUri)/contacts/$contactId"
        if ($PSCmdlet.ShouldProcess($contactId, "Remove contact")) {
            Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $resourceUri `
                -Method Delete `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop | `
                Out-Null
        }
    }
}
