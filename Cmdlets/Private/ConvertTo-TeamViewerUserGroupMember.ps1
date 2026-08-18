function ConvertTo-TeamViewerUserGroupMember {
    param(
        [Parameter(ValueFromPipeline)]
        [PSObject]
        $InputObject
    )

    process {
        $Properties = @{
            AccountId = [int]$InputObject.accountId
            Name      = $InputObject.name
        }

        $Result = New-Object -TypeName PSObject -Property $Properties
        $Result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.UserGroupMember')

        Write-Output $Result
    }
}
