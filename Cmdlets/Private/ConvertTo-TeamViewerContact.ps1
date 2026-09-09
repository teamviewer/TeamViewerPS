function ConvertTo-TeamViewerContact {
    param(
        [Parameter(ValueFromPipeline)]
        [object]
        $InputObject
    )

    process {
        $Properties = @{
            Id                 = $InputObject.contact_id
            Name               = $InputObject.name
            Description        = $InputObject.description
            UserId            = $InputObject.user_id
            GroupId           = $InputObject.groupid
            OnlineState        = $InputObject.online_state
            ProfilePicture_Url = $InputObject.profilepicture_url
            Features_Supported = $InputObject.supported_features
        }

        $Result = New-Object -TypeName PSObject -Property $Properties
        $Result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.Contact')

        Write-Output $Result
    }
}
