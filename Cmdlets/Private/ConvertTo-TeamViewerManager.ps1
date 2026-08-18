function ConvertTo-TeamViewerManager {
    param(
        [Parameter(ValueFromPipeline)]
        [PSObject]
        $InputObject,

        [Parameter(Mandatory = $true, ParameterSetName = 'GroupManager')]
        [guid]
        $GroupId,

        [Parameter(Mandatory = $true, ParameterSetName = 'DeviceManager')]
        [guid]
        $DeviceId
    )

    process {
        $Properties = @{
            Id          = [guid]$InputObject.id
            ManagerType = $InputObject.type
            Name        = $InputObject.name
            Permissions = $InputObject.permissions
        }

        switch ($InputObject.type) {
            'account' {
                $Properties.AccountId = $InputObject.accountId
            }
            'company' {
                $Properties.CompanyId = $InputObject.companyId
            }
        }

        switch ($PsCmdlet.ParameterSetName) {
            'GroupManager' {
                $Properties.GroupId = $GroupId
            }
            'DeviceManager' {
                $Properties.DeviceId = $DeviceId
            }
        }

        $Result = New-Object -TypeName PSObject -Property $Properties
        $Result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.Manager')

        Write-Output $Result
    }
}
