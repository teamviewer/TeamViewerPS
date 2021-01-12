function New-TeamViewerManagedGroup {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [string]
        $Name
    )

    $body = @{ name = $Name }
    $resourceUri = "$(Get-TeamViewerApiUri)/managed/groups"
    if ($PSCmdlet.ShouldProcess($Name, "Create managed group")) {
        $response = Invoke-TeamViewerRestMethod `
            -ApiToken $ApiToken `
            -Uri $resourceUri `
            -Method Post `
            -ContentType "application/json; charset=utf-8" `
            -Body ([System.Text.Encoding]::UTF8.GetBytes(($body | ConvertTo-Json))) `
            -WriteErrorTo $PSCmdlet `
            -ErrorAction Stop
        Write-Output ($response | ConvertTo-TeamViewerManagedGroup)
    }
}
