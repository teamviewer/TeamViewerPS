function ConvertTo-TeamViewerGroupShare {
    param(
        [Parameter(ValueFromPipeline)]
        [PSObject]
        $InputObject
    )

    begin {
        $properties = @{
            UserId      = $InputObject.userid
            Name        = $InputObject.name
            Permissions = $InputObject.permissions
        }
    }

    process {
        $result = New-Object -TypeName PSObject -Property $properties
        $result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.GroupShare')
        $result | Add-Member -MemberType ScriptMethod -Name 'ToString' -Force -Value {
            "$($this.UserId)"
        }

        $result
    }
}
