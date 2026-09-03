function ConvertTo-TeamViewerUserGroupMember {
    param(
        [Parameter(ValueFromPipeline)]
        [object]
        $InputObject
    )

    process {
        $Properties = @{
            Id   = [int]$InputObject.accountId
            Name = $InputObject.name
        }

        $Result = New-Object -TypeName PSObject -Property $Properties
        $Result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.UserGroupMember')

        Write-Output $Result
    }
}
