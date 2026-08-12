function ConvertTo-TeamViewerUserGroupMember {
    param(
        [Parameter(ValueFromPipeline)]
        [PSObject]
        $InputObject
    )

    begin {
        $properties = @{
            AccountId = [int]$InputObject.accountId
            Name      = $InputObject.name
        }
    }

    process {
        $result = New-Object -TypeName PSObject -Property $properties
        $result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.UserGroupMember')

        $result
    }
}
