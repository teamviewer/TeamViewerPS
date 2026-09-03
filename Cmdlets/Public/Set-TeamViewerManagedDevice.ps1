function Set-TeamViewerManagedDevice {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType([void])]

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

    begin {
        $Body = @{}

        if ($Name) {
            $Body['name'] = $Name
        }

        switch ($PsCmdlet.ParameterSetName) {
            'ByPolicyId' {
                $Body['teamviewerPolicyId'] = ($Policy | Resolve-TeamViewerPolicyId).ToString()
            }
            'ByManagedGroupId' {
                $Body['managedGroupId'] = ($ManagedGroup | Resolve-TeamViewerManagedGroupId).ToString()
            }
            'UpdateDescription' {
                $Body['deviceDescription'] = $Description
            }
        }

        if ($Body.Count -eq 0) {
            $PSCmdlet.ThrowTerminatingError(
                ('The given input does not change the managed device.' | `
                    ConvertTo-ErrorRecord -ErrorCategory InvalidArgument))
        }
    }

    process {
        $DeviceId = $Device | Resolve-TeamViewerManagedDeviceId
        $ResourceUri = "$(Get-TeamViewerApiUri)/managed/devices/$DeviceId"

        switch ($PsCmdlet.ParameterSetName) {
            'UpdateDescription' {
                $ResourceUri += '/description'
            }
        }

        if ($PSCmdlet.ShouldProcess($Device.ToString(), 'Change managed device entry')) {
            Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
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
