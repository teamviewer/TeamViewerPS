function New-TeamViewerGroup {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [string]
        $Name,

        [Parameter()]
        [ValidateScript( { $_ | Resolve-TeamViewerPolicyId } )]
        [Alias("PolicyId")]
        [object]
        $Policy
    )

    $body = @{ name = $Name }
    if ($Policy) {
        $body["policy_id"] = $Policy | Resolve-TeamViewerPolicyId
    }

    $resourceUri = "$(Get-TeamViewerApiUri)/groups"
    if ($PSCmdlet.ShouldProcess($Name, "Create group")) {
        $response = Invoke-TeamViewerRestMethod `
            -ApiToken $ApiToken `
            -Uri $resourceUri `
            -Method Post `
            -ContentType "application/json; charset=utf-8" `
            -Body ([System.Text.Encoding]::UTF8.GetBytes(($body | ConvertTo-Json))) `
            -WriteErrorTo $PSCmdlet `
            -ErrorAction Stop
        Write-Output ($response | ConvertTo-TeamViewerGroup)
    }
}
