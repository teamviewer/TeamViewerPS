
function New-TeamViewerRole {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType('TeamViewerPS.Role')]

    param(
        [Parameter(Mandatory = $true )]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [Alias('RoleName')]
        [string]
        $Name,

        [Parameter(Mandatory = $false)]
        [AllowEmptyCollection()]
        [object[]]
        $Permissions
    )

    begin {
        $ResourceUri = "$(Get-TeamViewerApiUri)/userroles"
        $Body = @{
            Name        = $Name
            Permissions = @()
        }

        if ($Permissions) {
            $Body.Permissions = @($Permissions)
        }
    }

    process {
        if ($PSCmdlet.ShouldProcess($Name, 'Create Role')) {
            $Response = Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $ResourceUri `
                -Method Post `
                -ContentType 'application/json; charset=utf-8' `
                -Body ([System.Text.Encoding]::UTF8.GetBytes(($Body | ConvertTo-Json))) `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop

            $Result = ($Response.Role | ConvertTo-TeamViewerRole)

            Write-Output $Result
        }
    }
}
