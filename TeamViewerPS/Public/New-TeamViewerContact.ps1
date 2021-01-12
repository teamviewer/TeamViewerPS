function New-TeamViewerContact {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [Alias('EmailAddress')]
        [string]
        $Email,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerGroupId } )]
        [Alias("GroupId")]
        [object]
        $Group,

        [Parameter()]
        [switch]
        $Invite
    )

    $body = @{
        email   = $Email
        groupid = $Group | Resolve-TeamViewerGroupId
    }
    if ($Invite) {
        $body['invite'] = $true
    }

    $resourceUri = "$(Get-TeamViewerApiUri)/contacts"
    if ($PSCmdlet.ShouldProcess($Email, "Create contact")) {
        $response = Invoke-TeamViewerRestMethod `
            -ApiToken $ApiToken `
            -Uri $resourceUri `
            -Method Post `
            -ContentType "application/json; charset=utf-8" `
            -Body ([System.Text.Encoding]::UTF8.GetBytes(($body | ConvertTo-Json))) `
            -WriteErrorTo $PSCmdlet `
            -ErrorAction Stop

        $result = ($response | ConvertTo-TeamViewerContact)
        Write-Output $result
    }
}
