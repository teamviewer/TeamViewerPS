
function New-TeamViewerRole {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType('TeamViewerPS.Role')]

    param(
        [Parameter(Mandatory = $true )]
        [securestring]
        $APIToken,

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
        $Resource_Uri = "$(Get-TeamViewerAPIUri)/userroles"
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
                -APIToken $APIToken `
                -Uri $Resource_Uri `
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
