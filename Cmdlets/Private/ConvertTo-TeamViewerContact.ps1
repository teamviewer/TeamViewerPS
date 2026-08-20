function ConvertTo-TeamViewerContact {
    param(
        [Parameter(ValueFromPipeline)]
        [object]
        $InputObject
    )

    process {
        $Properties = @{
            Id                = $InputObject.contact_id
            UserId            = $InputObject.user_id
            GroupId           = $InputObject.groupid
            Name              = $InputObject.name
            Description       = $InputObject.description
            OnlineState       = $InputObject.online_state
            ProfilePictureUrl = $InputObject.profilepicture_url
            SupportedFeatures = $InputObject.supported_features
        }

        $Result = New-Object -TypeName PSObject -Property $Properties
        $Result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.Contact')
        $Result | Add-Member -MemberType ScriptMethod -Name 'ToString' -Force -Value {
            "$($this.Name)"
        }

        Write-Output $Result
    }
}
