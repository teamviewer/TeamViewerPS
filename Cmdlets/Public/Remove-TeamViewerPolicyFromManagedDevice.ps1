function Remove-TeamviewerPolicyFromManagedDevice {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType([void])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedDeviceId } )]
        [Alias('DeviceId')]
        [object]
        $Device,

        [Parameter(Mandatory = $true)]
        [PolicyType]
        $PolicyType
    )

    begin {
        $Body = @{
            'policy_type' = [int]$PolicyType
        }
    }

    process {
        $DeviceId = $Device | Resolve-TeamViewerManagedDeviceId
        $ResourceUri = "$(Get-TeamViewerAPIUri)/managed/devices/$DeviceId/policy/remove"

        if ($PSCmdlet.ShouldProcess($DeviceId, 'Change managed device entry')) {
            Invoke-TeamViewerRestMethod `
                -APIToken $APIToken `
                -Uri $ResourceUri `
                -Method Put `
                -ContentType 'application/json; charset=utf-8' `
                -Body ([System.Text.Encoding]::UTF8.GetBytes(($Body | ConvertTo-Json))) `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop | `
                Out-Null
        }
    }
}
