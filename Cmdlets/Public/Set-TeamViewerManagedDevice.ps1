function Set-TeamViewerManagedDevice {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true, ParameterSetName = 'Default')]
        [Parameter(Mandatory = $true, ParameterSetName = 'ByPolicyId')]
        [Parameter(Mandatory = $true, ParameterSetName = 'ByManagedGroupId')]
        [Parameter(Mandatory = $true, ParameterSetName = 'UpdateDescription')]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true, ParameterSetName = 'Default', ValueFromPipeline = $true)]
        [Parameter(Mandatory = $true, ParameterSetName = 'ByPolicyId', ValueFromPipeline = $true)]
        [Parameter(Mandatory = $true, ParameterSetName = 'ByManagedGroupId', ValueFromPipeline = $true)]
        [Parameter(Mandatory = $true, ParameterSetName = 'UpdateDescription', ValueFromPipeline = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedDeviceId } )]
        [Alias('DeviceId')]
        [object]
        $Device,

        [Parameter(Mandatory = $false, ParameterSetName = 'Default')]
        [Parameter(Mandatory = $false, ParameterSetName = 'ByPolicyId')]
        [Parameter(Mandatory = $false, ParameterSetName = 'ByManagedGroupId')]
        [Parameter(Mandatory = $false, ParameterSetName = 'UpdateDescription')]
        [Alias('Alias')]
        [string]
        $Name,

        [Parameter(Mandatory = $true, ParameterSetName = 'ByPolicyId')]
        [ValidateScript( { $_ | Resolve-TeamViewerPolicyId } )]
        [Alias('PolicyId')]
        [object]
        $Policy,

        [Parameter(Mandatory = $true, ParameterSetName = 'ByManagedGroupId')]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedGroupId } )]
        [Alias('ManagedGroupId')]
        [object]
        $ManagedGroup,

        [Parameter(Mandatory = $true, ParameterSetName = 'UpdateDescription')]
        [Alias('DeviceDescription')]
        [string]
        $Description
    )
    Begin {
        $body = @{}

        if ($Name) {
            $body['name'] = $Name
        }

        switch ($PsCmdlet.ParameterSetName) {
            'ByPolicyId' {
                $body['teamviewerPolicyId'] = $Policy | Resolve-TeamViewerPolicyId
            }
            'ByManagedGroupId' {
                $body['managedGroupId'] = $ManagedGroup | Resolve-TeamViewerManagedGroupId
            }
            'UpdateDescription' {
                $body['deviceDescription'] = $Description
            }
        }

        if ($body.Count -eq 0) {
            $PSCmdlet.ThrowTerminatingError(
                ('The given input does not change the managed device.' | `
                    ConvertTo-ErrorRecord -ErrorCategory InvalidArgument))
        }
    }
    Process {
        $deviceId = $Device | Resolve-TeamViewerManagedDeviceId
        $resourceUri = "$(Get-TeamViewerApiUri)/managed/devices/$deviceId"

        switch ($PsCmdlet.ParameterSetName) {
            'UpdateDescription' {
                $resourceUri += '/description'
            }
        }

        if ($PSCmdlet.ShouldProcess($Device.ToString(), 'Change managed device entry')) {
            Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $resourceUri `
                -Method Put `
                -ContentType 'application/json; charset=utf-8' `
                -Body ([System.Text.Encoding]::UTF8.GetBytes(($body | ConvertTo-Json))) `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop | `
                Out-Null
        }
    }
}
