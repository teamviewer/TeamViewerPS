function ConvertTo-TeamViewerContact {
    param(
        [Parameter(ValueFromPipeline)]
        [PSObject]
        $InputObject
    )

    begin {
        $properties = @{
            Id                = [int]$InputObject.contact_id
            UserId            = [int]$InputObject.user_id
            GroupId           = [int]$InputObject.groupid
            Name              = $InputObject.name
            Description       = $InputObject.description
            OnlineState       = $InputObject.online_state
            ProfilePictureUrl = $InputObject.profilepicture_url
            SupportedFeatures = $InputObject.supported_features
        }
    }
    process {
        $result = New-Object -TypeName PSObject -Property $properties
        $result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.Contact')
        $result | Add-Member -MemberType ScriptMethod -Name 'ToString' -Force -Value {
            "$($this.Name)"
        }

        $result
    }
}
