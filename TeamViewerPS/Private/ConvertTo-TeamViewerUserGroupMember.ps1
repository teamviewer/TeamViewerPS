function ConvertTo-TeamViewerUserGroupMember {
    param(
        [Parameter(ValueFromPipeline)]
        [PSObject]
        $InputObject
    )
    process {
        $properties = @{
            AccountId = [int]$InputObject.accountId
            Name      = $InputObject.name
        }
        $result = New-Object -TypeName PSObject -Property $properties
        $result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.UserGroupMember')
        Write-Output $result
    }
}
