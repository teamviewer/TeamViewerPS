function New-TeamViewerContact {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType('TeamViewerPS.Contact')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken,

        [Parameter(Mandatory = $true)]
        [Alias('EmailAddress')]
        [string]
        $Email,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerGroupId } )]
        [Alias('GroupId')]
        [object]
        $Group,

        [Parameter()]
        [switch]
        $Invite
    )

    $Body = @{
        email   = $Email
        groupid = $Group | Resolve-TeamViewerGroupId
    }

    if ($Invite) {
        $Body['invite'] = $true
    }

    $ResourceUri = "$(Get-TeamViewerAPIUri)/contacts"

    if ($PSCmdlet.ShouldProcess($Email, 'Create contact')) {
        $Response = Invoke-TeamViewerRestMethod `
            -APIToken $APIToken `
            -Uri $ResourceUri `
            -Method Post `
            -ContentType 'application/json; charset=utf-8' `
            -Body ([System.Text.Encoding]::UTF8.GetBytes(($Body | ConvertTo-Json))) `
            -WriteErrorTo $PSCmdlet `
            -ErrorAction Stop

        $Result = ($Response | ConvertTo-TeamViewerContact)

        Write-Output $Result
    }
}
