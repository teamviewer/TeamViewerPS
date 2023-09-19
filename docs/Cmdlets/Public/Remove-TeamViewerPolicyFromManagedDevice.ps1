function Remove-TeamviewerPolicyFromManagedDevice {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedDeviceId } )]
        [Alias("DeviceId")]
        [object]
        $Device,

        [Parameter(Mandatory = $true)]
        [PolicyType]
        $PolicyType
    )
    Begin {
        $body = @{
            'policy_type' = [int]$PolicyType
        }
    }
    Process {
        $deviceId = $Device | Resolve-TeamViewerManagedDeviceId
        $resourceUri = "$(Get-TeamViewerApiUri)/managed/devices/$deviceId/policy/remove"

        if ($PSCmdlet.ShouldProcess($Device.ToString(), "Change managed device entry")) {
            Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $resourceUri `
                -Method Put `
                -ContentType "application/json; charset=utf-8" `
                -Body ([System.Text.Encoding]::UTF8.GetBytes(($body | ConvertTo-Json))) `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop | `
                Out-Null
        }
    }
}
