function ConvertTo-TeamViewerContact {
    param(
        [Parameter(ValueFromPipeline)]
        [PSObject]
        $InputObject
    )
    process {
        $properties = @{
            Id                = $InputObject.contact_id
            UserId            = $InputObject.user_id
            GroupId           = $InputObject.groupid
            Name              = $InputObject.name
            Description       = $InputObject.description
            OnlineState       = $InputObject.online_state
            ProfilePictureUrl = $InputObject.profilepicture_url
            SupportedFeatures = $InputObject.supported_features
        }
        $result = New-Object -TypeName PSObject -Property $properties
        $result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.Contact')
        $result | Add-Member -MemberType ScriptMethod -Name "ToString" -Force -Value {
            Write-Output "$($this.Name)"
        }
        Write-Output $result
    }
}
