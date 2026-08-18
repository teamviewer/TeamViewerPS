function ConvertTo-TeamViewerGroupShare {
    param(
        [Parameter(ValueFromPipeline)]
        [PSObject]
        $InputObject
    )

    process {
        $Properties = @{
            UserId      = $InputObject.userid
            Name        = $InputObject.name
            Permissions = $InputObject.permissions
        }

        $Result = New-Object -TypeName PSObject -Property $Properties
        $Result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.GroupShare')
        $Result | Add-Member -MemberType ScriptMethod -Name 'ToString' -Force -Value {
            "$($this.UserId)"
        }

        Write-Output $Result
    }
}
