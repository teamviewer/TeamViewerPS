enum TeamViewerConnectionReportSessionType {
    RemoteConnection = 1
    RemoteSupportActive = 2
    RemoteSupportActiveSdk = 3
}

enum PolicyType {
    TeamViewer = 1
    Monitoring = 4
    PatchManagement = 5
}



function Add-Registry {
    param (
        [Microsoft.Win32.RegistryKey]$RegKey,
        [string]$Program
    )

    #CustomObject including all information for each registry and sub keys
    $retRegKey = [PSCustomObject]@{
        Program      = $Program
        RegistryPath = $RegKey.Name
        Entries      = @()
    }
    Write-Output "Collecting registry data $($retRegKey.RegistryPath)"
    foreach ($valueName in $RegKey.GetValueNames()) {
        $value = $RegKey.GetValue($valueName)
        $type, $value = Get-TypeAndValueOfRegistryValue -RegKey $RegKey -ValueName $valueName
        $blackList = @('BuddyLoginTokenAES', 'BuddyLoginTokenSecretAES', 'Certificate', 'CertificateKey', 'CertificateKeyProtected',
            'MultiPwdMgmtPwdData', 'PermanentPassword', 'PK', 'SecurityPasswordAES', 'SK', 'SRPPasswordMachineIdentifier')
        foreach ($blackListValue in $blackList) {
            if ($valueName -eq $blackListValue) {
                $value = '___PRIVATE___'
            }
        }
        $entry = [PSCustomObject]@{
            Name  = $valueName
            Value = $value
            Type  = $type
        }
        $retRegKey.Entries += $entry
    }

    foreach ($subKeyName in $RegKey.GetSubKeyNames()) {
        $subKey = $RegKey.OpenSubKey($subKeyName)
        Add-Registry -RegKey $subKey -Program $subKeyName
    }
    #Adding CustomObject to array declared in Get-RegistryPaths
    $AllTVRegistryData.Add($retRegKey) | Out-Null
}





function ConvertTo-DateTime {
    param(
        [Parameter(ValueFromPipeline)]
        [string]
        $InputString
    )

    process {
        try {
            Write-Output ([DateTime]::Parse($InputString))
        }
        catch {
            Write-Output $null
        }
    }
}


function ConvertTo-ErrorRecord {
    param(
        [Parameter(ValueFromPipeline)]
        [object]
        $InputObject,

        [Parameter()]
        [System.Management.Automation.ErrorCategory]
        $ErrorCategory = [System.Management.Automation.ErrorCategory]::NotSpecified
    )
    Process {
        $category = $ErrorCategory
        $message = $InputObject.ToString()
        $errorId = 'TeamViewerError'

        if ($InputObject.PSObject.TypeNames -contains 'TeamViewerPS.RestError') {
            $category = switch ($InputObject.ErrorCategory) {
                'invalid_request' { [System.Management.Automation.ErrorCategory]::InvalidArgument }
                'invalid_token' { [System.Management.Automation.ErrorCategory]::AuthenticationError }
                'internal_error' { [System.Management.Automation.ErrorCategory]::NotSpecified }
                'rate_limit_reached' { [System.Management.Automation.ErrorCategory]::LimitsExceeded }
                'token_expired' { [System.Management.Automation.ErrorCategory]::AuthenticationError }
                'wrong_credentials' { [System.Management.Automation.ErrorCategory]::AuthenticationError }
                'invalid_client' { [System.Management.Automation.ErrorCategory]::InvalidArgument }
                'not_found' { [System.Management.Automation.ErrorCategory]::ObjectNotFound }
                'too_many_retries' { [System.Management.Automation.ErrorCategory]::LimitsExceeded }
                'invalid_permission' { [System.Management.Automation.ErrorCategory]::PermissionDenied }
                default { [System.Management.Automation.ErrorCategory]::NotSpecified }
            }
            $errorId = 'TeamViewerRestError'
        }

        $exception = [System.Management.Automation.RuntimeException]($message)
        $errorRecord = New-Object System.Management.Automation.ErrorRecord $exception, $errorId, $category, $null
        $errorRecord.ErrorDetails = $message
        return $errorRecord
    }
}



function ConvertTo-TeamViewerAccount {
    param(
        [Parameter(ValueFromPipeline)]
        [PSObject]
        $InputObject
    )
    process {
        $properties = @{
            Name             = $InputObject.name
            Email            = $InputObject.email
            UserId           = $InputObject.userid
            CompanyName      = $InputObject.company_name
            IsEmailValidated = $InputObject.email_validated
            EmailLanguage    = $InputObject.email_language
        }
        if ($InputObject.email_language -And $InputObject.email_language -Ne 'auto') {
            $properties["EmailLanguage"] = [System.Globalization.CultureInfo]($InputObject.email_language)
        }
        $result = New-Object -TypeName PSObject -Property $properties
        $result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.Account')
        $result | Add-Member -MemberType ScriptMethod -Name "ToString" -Force -Value {
            Write-Output "$($this.Name) <$($this.Email)>"
        }
        Write-Output $result
    }
}



function ConvertTo-TeamViewerAuditEvent {
    param(
        [Parameter(ValueFromPipeline)]
        [PSObject]
        $InputObject
    )
    process {
        $properties = @{
            Name         = $InputObject.EventName
            Type         = $InputObject.EventType
            Timestamp    = $InputObject.Timestamp | ConvertTo-DateTime
            Author       = $InputObject.Author
            AffectedItem = $InputObject.AffectedItem
            EventDetails = $InputObject.EventDetails
        }
        $result = New-Object -TypeName PSObject -Property $properties
        $result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.AuditEvent')
        $result | Add-Member -MemberType ScriptMethod -Name "ToString" -Force -Value {
            Write-Output "[$($this.Timestamp)] $($this.Name) ($($this.Type))"
        }
        Write-Output $result
    }
}



function ConvertTo-TeamViewerConnectionReport {
    param(
        [Parameter(ValueFromPipeline)]
        [PSObject]
        $InputObject
    )
    process {
        $properties = @{
            Id                 = $InputObject.id
            UserId             = $InputObject.userid
            UserName           = $InputObject.username
            DeviceId           = $InputObject.deviceid
            DeviceName         = $InputObject.devicename
            GroupId            = $InputObject.groupid
            GroupName          = $InputObject.groupname
            SupportSessionType = [TeamViewerConnectionReportSessionType]$InputObject.support_session_type
            StartDate          = $InputObject.start_date | ConvertTo-DateTime
            EndDate            = $InputObject.end_date | ConvertTo-DateTime
            SessionCode        = $InputObject.session_code
            Fee                = $InputObject.fee
            BillingState       = $InputObject.billing_state
            Currency           = $InputObject.currency
            Notes              = $InputObject.notes
        }

        $result = New-Object -TypeName PSObject -Property $properties
        $result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.ConnectionReport')
        Write-Output $result
    }
}



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



function ConvertTo-TeamViewerDevice {
    param(
        [Parameter(ValueFromPipeline)]
        [PSObject]
        $InputObject
    )
    process {
        $remoteControlId = $InputObject.remotecontrol_id | `
            Select-String -Pattern 'r(\d+)' | `
            ForEach-Object { $_.Matches.Groups[1].Value }
        $properties = @{
            Id                         = $InputObject.device_id
            TeamViewerId               = $remoteControlId
            GroupId                    = $InputObject.groupid
            Name                       = $InputObject.alias
            Description                = $InputObject.description
            OnlineState                = $InputObject.online_state
            IsAssignedToCurrentAccount = $InputObject.assigned_to
            SupportedFeatures          = $InputObject.supported_features
        }
        if ($InputObject.policy_id) {
            $properties['PolicyId'] = $InputObject.policy_id
        }
        if ($InputObject.last_seen) {
            $properties['LastSeenAt'] = [datetime]($InputObject.last_seen)
        }
        $result = New-Object -TypeName PSObject -Property $properties
        $result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.Device')
        $result | Add-Member -MemberType ScriptMethod -Name "ToString" -Force -Value {
            Write-Output "$($this.Name)"
        }
        Write-Output $result
    }
}



function ConvertTo-TeamViewerGroup {
    param(
        [Parameter(ValueFromPipeline)]
        [PSObject]
        $InputObject
    )
    process {
        $properties = @{
            Id          = $InputObject.id
            Name        = $InputObject.name
            Permissions = $InputObject.permissions
            SharedWith  = @($InputObject.shared_with | ConvertTo-TeamViewerGroupShare)
        }
        if ($InputObject.owner) {
            $properties.Owner = [pscustomobject]@{
                UserId = $InputObject.owner.userid
                Name   = $InputObject.owner.name
            }
        }
        $result = New-Object -TypeName PSObject -Property $properties
        $result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.Group')
        Write-Output $result
    }
}


function ConvertTo-TeamViewerGroupShare {
    param(
        [Parameter(ValueFromPipeline)]
        [PSObject]
        $InputObject
    )
    process {
        $properties = @{
            UserId      = $InputObject.userid
            Name        = $InputObject.name
            Permissions = $InputObject.permissions
        }
        $result = New-Object -TypeName PSObject -Property $properties
        $result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.GroupShare')
        $result | Add-Member -MemberType ScriptMethod -Name "ToString" -Force -Value {
            Write-Output "$($this.UserId)"
        }
        Write-Output $result
    }
}


function ConvertTo-TeamViewerManagedDevice {
    param(
        [Parameter(ValueFromPipeline)]
        [PSObject]
        $InputObject
    )
    process {
        $properties = @{
            Id           = [guid]$InputObject.id
            Name         = $InputObject.name
            TeamViewerId = $InputObject.TeamViewerId
            IsOnline     = $InputObject.isOnline
        }

        if ($InputObject.last_seen) {
            $properties['LastSeenAt'] = Get-Date -Date $InputObject.last_seen
        }

        if ($InputObject.teamviewerPolicyId) {
            $properties["PolicyId"] = [guid]$InputObject.teamviewerPolicyId
        }

        $result = New-Object -TypeName PSObject -Property $properties
        $result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.ManagedDevice')
        Write-Output $result
    }
}



function ConvertTo-TeamViewerManagedGroup {
    param(
        [Parameter(ValueFromPipeline)]
        [PSObject]
        $InputObject
    )
    process {
        $properties = @{
            Id   = [guid]$InputObject.id
            Name = $InputObject.name
        }
        if ($InputObject.policy_id) {
            $properties["PolicyId"] = $InputObject.policy_id
        }
        $result = New-Object -TypeName PSObject -Property $properties
        $result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.ManagedGroup')
        Write-Output $result
    }
}



function ConvertTo-TeamViewerManager {
    param(
        [Parameter(ValueFromPipeline)]
        [PSObject]
        $InputObject,

        [Parameter(Mandatory = $true, ParameterSetName = "GroupManager")]
        [guid]
        $GroupId,

        [Parameter(Mandatory = $true, ParameterSetName = "DeviceManager")]
        [guid]
        $DeviceId
    )
    process {
        $properties = @{
            Id          = [guid]$InputObject.id
            ManagerType = $InputObject.type
            Name        = $InputObject.name
            Permissions = $InputObject.permissions
        }

        switch ($InputObject.type) {
            'account' {
                $properties.AccountId = $InputObject.accountId
            }
            'company' {
                $properties.CompanyId = $InputObject.companyId
            }
        }

        switch ($PsCmdlet.ParameterSetName) {
            'GroupManager' {
                $properties.GroupId = $GroupId
            }
            'DeviceManager' {
                $properties.DeviceId = $DeviceId
            }
        }

        $result = New-Object -TypeName PSObject -Property $properties
        $result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.Manager')
        Write-Output $result
    }
}



function ConvertTo-TeamViewerPolicy {
    param(
        [Parameter(ValueFromPipeline)]
        [PSObject]
        $InputObject
    )

    process {
        $properties = @{
            Id       = $InputObject.policy_id
            Name     = $InputObject.name
            Settings = @(
                $InputObject.settings | ForEach-Object {
                    @{
                        Key     = $_.key
                        Value   = $_.value
                        Enforce = $_.enforce
                    }
                }
            )
        }

        $result = New-Object -TypeName PSObject -Property $properties
        $result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.Policy')
        Write-Output $result
    }
}



function ConvertTo-TeamViewerRestError {
    param(
        [parameter(ValueFromPipeline)]
        $InputError
    )
    Process {
        try {
            $errorObject = ($InputError | Out-String | ConvertFrom-Json)
            $result = [PSCustomObject]@{
                Message        = $errorObject.error_description
                ErrorCategory  = $errorObject.error
                ErrorCode      = $errorObject.error_code
                ErrorSignature = $errorObject.error_signature
            }
            $result | Add-Member -MemberType ScriptMethod -Name 'ToString' -Force -Value {
                Write-Output "$($this.Message) ($($this.ErrorCategory))"
            }
            $result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.RestError')
            return $result
        }
        catch {
            return $InputError
        }
    }
}



function ConvertTo-TeamViewerRoleAssignedUser {
    param(
        [Parameter(ValueFromPipeline)]
        [PSObject]
        $InputObject
    )
    process {
        $properties = @{AssignedUsers = ($InputObject.trim('u'))}
        $result = New-Object -TypeName PSObject -Property $properties
        $result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.RoleAssignedUser')
        Write-Output $result
    }
}



function ConvertTo-TeamViewerRoleAssignedUserGroup {
    param(
        [Parameter(ValueFromPipeline)]
        [PSObject]
        $InputObject
    )
    process {
        $properties = @{AssignedGroups = ($InputObject)}
        $result = New-Object -TypeName PSObject -Property $properties
        $result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.RoleAssignedUserGroup')
        Write-Output $result
    }
}



function ConvertTo-TeamViewerSsoDomain {
    param(
        [Parameter(ValueFromPipeline)]
        [PSObject]
        $InputObject
    )
    process {
        $properties = @{
            Id   = $InputObject.DomainId
            Name = $InputObject.DomainName
        }
        $result = New-Object -TypeName PSObject -Property $properties
        $result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.SsoDomain')
        $result | Add-Member -MemberType ScriptMethod -Name "ToString" -Force -Value {
            Write-Output "$($this.Name)"
        }
        Write-Output $result
    }
}



function ConvertTo-TeamViewerUser {
    param(
        [Parameter(ValueFromPipeline)]
        [PSObject]
        $InputObject,

        [Parameter()]
        [ValidateSet('All', 'Minimal')]
        $PropertiesToLoad = 'All'
    )
    process {
        $properties = @{
            Id    = $InputObject.id
            Name  = $InputObject.name
            Email = $InputObject.email
        }
        if ($PropertiesToLoad -Eq 'All') {
            $properties += @{
                Permissions    = $InputObject.permissions -split ','
                Active         = $InputObject.active
                LastAccessDate = $InputObject.last_access_date | ConvertTo-DateTime
            }
            if ($InputObject.activated_license_id) {
                $properties += @{
                    ActivatedLicenseId      = [guid]$InputObject.activated_license_id
                    ActivatedLicenseName    = $InputObject.activated_license_name
                    ActivatedSubLicenseName = $InputObject.activated_subLicense_name
                }
            }
            if ($InputObject.activated_meeting_license_key) {
                $properties += @{
                    ActivatedMeetingLicenseId = [guid]$InputObject.activated_meeting_license_key
                }
            }
        }
        $result = New-Object -TypeName PSObject -Property $properties
        $result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.User')
        $result | Add-Member -MemberType ScriptMethod -Name "ToString" -Force -Value {
            Write-Output "$($this.Name) <$($this.Email)>"
        }
        Write-Output $result
    }
}



function ConvertTo-TeamViewerUserGroup {
    param(
        [Parameter(ValueFromPipeline)]
        [PSObject]
        $InputObject
    )
    process {
        $properties = @{
            Id   = [UInt64]$InputObject.id
            Name = $InputObject.name
        }
        $result = New-Object -TypeName PSObject -Property $properties
        $result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.UserGroup')
        Write-Output $result
    }
}



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



function ConvertTo-TeamViewerUserRole {
    param(
        [Parameter(ValueFromPipeline)]
        [PSObject]
        $InputObject
    )
    process {
        $properties = @{
            RoleName = $InputObject.Name
            RoleID   = $InputObject.Id
        }
        if ($InputObject.Permissions) {
            foreach ($permission in $InputObject.Permissions.PSObject.Properties) {
                $properties[$permission.Name] = $permission.Value
            }
        }
        $result = New-Object -TypeName PSObject -Property $properties
        $result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.UserRole')
        $result | Add-Member -MemberType ScriptMethod -Name 'ToString' -Force -Value {
            Write-Output "[$($this.RoleName)] [$($this.RoleID)] $($this.Permissions))"
        }
        Write-Output $result
    }
}




function Get-ClientId {
    if (Test-Path -Path 'HKLM:\SOFTWARE\Wow6432Node\TeamViewer') {
        $mainKey = Get-ItemProperty -Path 'HKLM:\SOFTWARE\Wow6432Node\TeamViewer'
        $id = [int]$mainKey.ClientID
    }
    elseif (Test-Path -Path 'HKLM:\Software\TeamViewer') {
        $mainKey = Get-ItemProperty -Path 'HKLM:\Software\TeamViewer'
        $id = [int]$mainKey.ClientID
    }
    return $id
}



function Get-HostFile {
    param(
        [Parameter(ValueFromPipeline = $true)]
        [string]
        $OutputPath
    )
    process {
        $regPath = 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters'
        $regKey = Get-ItemProperty -Path $regPath
        $hostsPath = Join-Path -Path $regKey.DataBasePath -ChildPath 'hosts'
        $hostsFile = Get-Content -Path $hostsPath
        $hostsFile | Out-File -FilePath "$OutputPath\Data\hosts.txt"
        Write-Output "hosts file collected and saved to $OutputPath\Data\hosts.txt"
    }
}



function Get-InstalledSoftware {
    param(
        [Parameter(ValueFromPipeline = $true)]
        [string]
        $OutputPath
    )
    Begin {
        $regUninstall = @{
            InstalledSoftware32 = 'HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall'
            InstalledSoftware64 = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall'
        }
    }
    Process {
        foreach ($Name in $regUninstall.keys) {
            $regKeys = $regUninstall[$Name]
            $regKey = Get-ItemProperty -Path "$regKeys\*"
            if ($null -ne $regKey) {
                $subKeys = $regKey.PSChildName
                if ($null -ne $subKeys) {
                    $installedPrograms = @()
                    foreach ($subKey in $subKeys) {
                        $tmpSubkey = Get-ItemProperty -Path "$regKeys\$subKey"
                        $programmName = $tmpSubkey.DisplayName
                        $displayVersion = $tmpSubkey.DisplayVersion
                        if ($null -ne $programmName) {
                            $tmpSoftwareData = "$programmName | $displayVersion"
                            $installedPrograms += $tmpSoftwareData
                        }
                    }
                }
                $installedPrograms | Sort-Object | Out-File -FilePath "$OutputPath\Data\$Name.txt"
                Write-Output "$Name collected and saved to $OutputPath\Data\$Name.txt"
            }
        }
    }
}





function Get-IpConfig {
    param(
        [Parameter(ValueFromPipeline = $true)]
        [string]
        $OutputPath
    )
    Process {
        try {
            ipconfig /all | Out-File -FilePath "$OutputPath\Data\ipconfig.txt" -Encoding utf8
            Write-Output "ipconfig data collected and saved to $OutputPath\Data\ipconfig.txt"
        }
        catch {
            Write-Error "An error occurred while collecting ipconfig data: $_"
        }
    }
}



function Get-MSInfo32 {
    param(
        [Parameter(ValueFromPipeline = $true)]
        [string]
        $OutputPath
    )
    Process {
        try {
            Start-Process -FilePath msinfo32.exe -ArgumentList "/nfo $OutputPath\Data\msinfo32.nfo" -Wait

            Write-Output "msinfo data collected and saved to $OutputPath\Data\msinfo32.nfo"
        }
        catch {
            Write-Error "An error occurred while collecting msinfo data: $_"
        }
    }
}



function Get-NSLookUpData {
    param(
        [Parameter(ValueFromPipeline = $true)]
        [string]
        $OutputPath
    )
    Begin {
        $Ipv4DnsServer = @($null, 'tv-ns1.teamviewer.com', 'tv-ns2.teamviewer.com', 'tv-ns3.teamviewer.com',
            'tv-ns4.teamviewer.com', 'tv-ns5.teamviewer.com', '8.8.8.8', '1.1.1.1')
        $Ipv4DnsName = @( 'master1.teamviewer.com', 'router1.teamviewer.com', 'google.com',
            'login.teamviewer.com', 'www.teamviewer.com')
        $output = $null
    }
    Process {
        try {
            foreach ($DnsName in $Ipv4DnsName ) {
                foreach ($DnsServer in $Ipv4DnsServer) {
                    Write-Output "Collecting nslookup.exe information from $DnsName $DnsServer. This might take a while"
                    $output += "nslookup information for:  $DnsName  $DnsServer `r`n"
                    $arguments = "-debug ""$DnsName"""
                    if ($DnsServer) {
                        $arguments += " ""$DnsServer"""
                    }
                    $processInfo = New-Object System.Diagnostics.ProcessStartInfo
                    $processInfo.FileName = 'nslookup.exe'
                    $processInfo.Arguments = $arguments
                    $processInfo.WindowStyle = 'Hidden'
                    $processInfo.UseShellExecute = $false
                    $processInfo.RedirectStandardOutput = $true

                    $process = [System.Diagnostics.Process]::Start($processInfo)
                    $output += $process.StandardOutput.ReadToEnd()
                    $process.WaitForExit(60000)
                    if (-not $process.HasExited) {
                        $process.Kill()
                        continue
                    }
                    $output += $process.StandardOutput.ReadToEnd()
                }
            }
            $output | Out-File "$OutputPath\Data\nslookup.txt"
        }

        catch {
            Write-Error "Error collecting nslookup information: $_"
        }
    }
}





function Get-OperatingSystem {
    if ($IsLinux) {
        return 'Linux'
    }
    if ($IsMacOS) {
        return 'MacOS'
    }
    if ($IsWindows -Or $env:OS -match '^Windows') {
        return 'Windows'
    }
}



function Get-RegistryPath {
    param(
        [Parameter(ValueFromPipeline = $true)]
        [string]
        $OutputPath
    )
    Begin {
        $SearchProgramms = @('TeamViewer', 'Blizz', 'TeamViewerMeeting')
        $RegistrySearchPathsLocalMachine = @('SOFTWARE\Wow6432Node', 'SOFTWARE')
        $RegistrySearchPathsCurrentUser = @('SOFTWARE')
        $AllTVRegistryData = New-Object System.Collections.ArrayList
    }

    Process {
        foreach ($searchProgramm in $SearchProgramms) {
            foreach ($registrySearchPath in $RegistrySearchPathsLocalMachine) {
                $regKey = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey("$registrySearchPath\$searchProgramm", $false)
                if ($regKey) {
                    Add-Registry -RegKey $regKey -Program $searchProgramm
                }
            }

            foreach ($registrySearchPath in $RegistrySearchPathsCurrentUser) {
                $regKey = [Microsoft.Win32.Registry]::CurrentUser.OpenSubKey("$registrySearchPath\$searchProgramm", $false)
                if ($searchProgramm -eq 'Blizz' -or $searchProgramm -eq 'TeamViewerMeeting') {
                    $regKey = [Microsoft.Win32.Registry]::CurrentUser.OpenSubKey("$registrySearchPath\$searchProgramm\MachineFallback", $false)
                }
                if ($regKey) {
                    Add-Registry -RegKey $regKey -Program $searchProgramm
                }
            }

            $output = "Windows Registry Editor Version 5.00 `r`n"
            foreach ($data in $AllTVRegistryData) {
                $output += "[$($data.RegistryPath)]`r`n"
                foreach ($entry in $data.Entries) {
                    if ($null -ne $entry.name) {
                        $output += """$($entry.Name)""" + $entry.Type + $entry.Value + "`r`n"
                    }
                }
                $output += "`r`n"
            }
            $output | Out-File -FilePath "$OutputPath\Data\TeamViewer_Version15\Reg_Version15.txt"
        }
    }

}



function Get-RouteTable {
    param(
        [Parameter(ValueFromPipeline = $true)]
        [string]
        $OutputPath
    )
Process{
    try {
        $processInfo = New-Object System.Diagnostics.ProcessStartInfo
        $processInfo.FileName = 'route.exe'
        $processInfo.Arguments = 'print'
        $processInfo.WindowStyle = 'Hidden'
        $processInfo.UseShellExecute = $false
        $processInfo.RedirectStandardOutput = $true

        $process = [System.Diagnostics.Process]::Start($processInfo)
        $output = $process.StandardOutput.ReadToEnd()
        $output | Out-File "$OutputPath\Data\RouteTable.txt"
    }
    catch {
        Write-Error "An error occurred while collecting RouteTable data: $_"
    }
}
}





class TeamViewerConfiguration {
    [string]$APIUri = 'https://webapi.teamviewer.com/api/v1'

    static [TeamViewerConfiguration] $Instance = $null

    static [TeamViewerConfiguration] GetInstance() {
        if (-not [TeamViewerConfiguration]::Instance) {
            [TeamViewerConfiguration]::Instance = [TeamViewerConfiguration]::new()
        }

        return [TeamViewerConfiguration]::Instance
    }
}

function Get-TeamViewerAPIUri {
    $config = [TeamViewerConfiguration]::GetInstance()
    return $config.APIUri
}





function Get-TeamViewerLinuxGlobalConfig {
    param(
        [Parameter()]
        [string]
        $Path = '/opt/teamviewer/config/global.conf',

        [Parameter()]
        [string]
        $Name
    )
    $config = & sudo pwsh -command Get-Content $Path | ForEach-Object {
        if ($_ -Match '\[(?<EntryType>\w+)\s*\]\s+(?<EntryName>[\w\\]+)\s+=\s*(?<EntryValue>.*)$') {
            $Matches.Remove(0)
            $entry = [pscustomobject]$Matches
            switch ($entry.EntryType) {
                'strng' {
                    $entry.EntryValue = $entry.EntryValue | `
                        Select-String -Pattern '"([^\"]*)"' -AllMatches | `
                        Select-Object -ExpandProperty Matches | `
                        ForEach-Object { $_.Groups[1].Value }
                }
                'int32' {
                    $entry.EntryValue = [int32]($entry.EntryValue)
                }
                'int64' {
                    #In some cases the EntryName DeviceManagement/TransitionNonces is set to entryvalue '0 0 0 0 0' of type int64
                    if ($entry.EntryValue -notmatch '0 0 0 0 0') {
                        $entry.EntryValue = [int64]($entry.EntryValue)
                    }
                }
            }
            $entry
        }
    }

    if ($Name) {
        ($config | Where-Object { $_.EntryName -eq $Name }).EntryValue
    }
    else {
        $config
    }
}



function Get-TeamViewerRegKeyPath {
    param (
        [Parameter()]
        [ValidateSet('WOW6432', 'Auto')]
        [string]
        $Variant = 'Auto'
    )
    if (($Variant -eq 'WOW6432') -Or (Test-TeamViewer32on64)) {
        Write-Output 'HKLM:\SOFTWARE\Wow6432Node\TeamViewer'
    }
    else {
        Write-Output 'HKLM:\SOFTWARE\TeamViewer'
    }
}



function Get-TeamViewerServiceName {
    Write-Output 'TeamViewer'
}



function Get-TSCDirectoryFile {
    param(
        [Parameter(ValueFromPipeline = $true)]
        [string]
        $OutputPath
    )

    Process {
        $SearchDirectories = Get-TSCSearchDirectory
        $TempDirectory = New-Item -Path $OutputPath -Name 'Data' -ItemType Directory -Force
        $Endings = @('.log', 'tvinfo.ini', '.mdmp', 'Connections.txt', 'Connections_incoming.txt')
        $TmpLogFiles = @()
        foreach ($Name in $SearchDirectories.Keys) {
            $SearchDirectory = $SearchDirectories[$Name]
            foreach ($Folder in $SearchDirectory) {
                if (Test-Path -Path $Folder) {
                    $TempSubdirectory = Join-Path -Path $TempDirectory -ChildPath $Name
                    New-Item -Path $TempSubdirectory -ItemType Directory -Force | Out-Null
                    $files = Get-ChildItem -Path $Folder -File -Recurse
                    foreach ($file in $files) {
                        foreach ($ending in $Endings) {
                            if ($file.Name.EndsWith($ending)) {
                                $tmpLogfilePath = Join-Path -Path $TempSubdirectory -ChildPath $file.Name
                                Copy-Item -Path $file.FullName -Destination $tmpLogfilePath -Force
                                $TmpLogFiles += $tmpLogfilePath
                                Write-Output "Collected log file from $($file.FullName)"
                            }
                        }
                    }
                }
            }
        }
        Write-Output 'Files from TeamViewer directories have been collected.'
    }
}



function Get-TSCSearchDirectory {
    $LocalAppData = [System.Environment]::GetFolderPath('LocalApplicationData')
    $RoamingAppData = [System.Environment]::GetFolderPath('ApplicationData')
    $TVAppData = Join-Path -Path $LocalAppData.ToString() -ChildPath 'TeamViewer/Logs'
    $TVRoamingData = Join-Path -Path $RoamingAppData.ToString() -ChildPath 'TeamViewer'
    $InstallationDirectory = Get-TeamViewerInstallationDirectory

    $TSCSearchDirectory = @{
        'TeamViewer_Version15' = $InstallationDirectory
        'AppData\TeamViewer'   = @($TVAppData; $TVRoamingData)
    }

    return $TSCSearchDirectory
}



function Get-TypeAndValueOfRegistryValue {
    param (
        [Microsoft.Win32.RegistryKey]$RegKey,
        [string]$ValueName
    )

    $valueKind = $RegKey.GetValueKind($ValueName)
    $type = $valueKind

    if ($valueKind -eq 'DWord') {
        $type = "=dword:"
        $value = [Convert]::ToInt32($RegKey.GetValue($ValueName)).ToString('x')
    }
    elseif ($valueKind -eq 'Binary') {
        $type = "=hex:"
        $value = ($RegKey.GetValue($ValueName) | ForEach-Object { $_.ToString('x2') }) -join ','
    }
    elseif ($valueKind -eq 'String') {
        $type = "="
        $value = $RegKey.GetValue($ValueName).ToString()
    }
    elseif ($valueKind -eq 'MultiString') {
        $type = "=hex(7):"
        $value += ($RegKey.GetValue($ValueName) | ForEach-Object {
                $_.ToCharArray() | ForEach-Object { [Convert]::ToInt32($_).ToString('X') + ',00' }
            }) -join ','
        $value += ',00,00,'
        if ($value.Length -gt 0) {
            $value += '00,00'
        }
    }
    else {
        $type = ""
        $value = $RegKey.GetValue($ValueName).ToString()
    }

    return $type, $value
}




function Invoke-ExternalCommand {
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]
        $Command,

        [Parameter(ValueFromRemainingArguments = $true)]
        [object[]]
        $CommandArgs
    )
    & $Command @CommandArgs
}



function Invoke-TeamViewerRestMethod {
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [uri]
        $Uri,

        [Microsoft.PowerShell.Commands.WebRequestMethod]
        $Method,

        [System.Collections.IDictionary]
        $Headers,

        [System.Object]
        $Body,

        [string]
        $ContentType,

        [System.Management.Automation.PSCmdlet]
        $WriteErrorTo

    )

    if (-Not $Headers) {
        $Headers = @{ }
        $PSBoundParameters.Add('Headers', $Headers) | Out-Null
    }

    if ($global:TeamViewerProxyUriSet) {
        $Proxy = $global:TeamViewerProxyUriSet
    }
    elseif ([Environment]::GetEnvironmentVariable('TeamViewerProxyUri') ) {
        $Proxy = [Environment]::GetEnvironmentVariable('TeamViewerProxyUri')
        if ($global:TeamViewerProxyUriRemoved) {
            $Proxy = $null
        }
    }
    If ($Proxy) {
        $PSBoundParameters.Add('Proxy', $Proxy) | Out-Null
    }
    $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($ApiToken)
    $Headers['Authorization'] = "Bearer $([System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr))"
    [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr) | Out-Null
    $PSBoundParameters.Remove('ApiToken') | Out-Null
    $PSBoundParameters.Remove('WriteErrorTo') | Out-Null

    $currentTlsSettings = [Net.ServicePointManager]::SecurityProtocol
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    $currentProgressPreference = $ProgressPreference
    $ProgressPreference = 'SilentlyContinue'


    # Using `Invoke-WebRequest` instead of `Invoke-RestMethod`:
    # There is a known issue for PUT and DELETE operations to hang on Windows Server 2012.
    try {

        return ((Invoke-WebRequest -UseBasicParsing @PSBoundParameters).Content | ConvertFrom-Json)
    }
    catch {
        $msg = $null
        if ($PSVersionTable.PSVersion.Major -ge 6) {
            $msg = $_.ErrorDetails.Message
        }
        elseif ($_.Exception.Response) {
            $stream = $_.Exception.Response.GetResponseStream()
            $reader = New-Object System.IO.StreamReader($stream)
            $reader.BaseStream.Position = 0
            $msg = $reader.ReadToEnd()
        }
        $err = ($msg | ConvertTo-TeamViewerRestError)
        if ($WriteErrorTo) {
            $WriteErrorTo.WriteError(($err | ConvertTo-ErrorRecord))
        }
        else {
            throw $err
        }
    }
    finally {
        [Net.ServicePointManager]::SecurityProtocol = $currentTlsSettings
        $ProgressPreference = $currentProgressPreference
    }
}



function  Resolve-AssignmentErrorCode {
    param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        [object]
        $exitCode
    )
    Begin {
        $exitCodeMessages = @{
            0   = 'Operation successful'
            1   = 'Misspelled or used a wrong command'
            2   = 'Signature verification error'
            3   = 'TeamViewer is not installed'
            4   = 'The assignment configuration could not be verified against the TeamViewer Cloud.Try again later.'
            400 = 'Invalid assignment ID'
            401 = 'TeamViewer service not running'
            402 = 'Service Incompatible Version'
            403 = 'Check your internet connection'
            404 = 'Another assignment process running'
            405 = 'Timeout'
            406 = 'Failed due to unknown reasons'
            407 = 'Access denied. Ensure local administrator rights'
            408 = 'Denied by policy'
        }
    }
    Process {
        if ($exitCode) {
            if ($exitCodeMessages.ContainsKey($exitCode)) {
                Write-Output $exitCodeMessages[$exitCode]
            }
            else {
                Write-Output "Unexpected error code: $exitCode. Check TeamViewer documentation!"
            }
        }
        elseif ($exitCode -eq 0) {
            Write-Output $exitCodeMessages[$exitCode]
        }
    }
}



function  Resolve-CustomizationErrorCode {
    param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        [object]
        $exitCode
    )
    Begin {
        $exitCodeMessages = @{
            0   = 'Operation successful'
            1   = 'Invalid command line arguments'
            500 = 'An internal error occurred. See TeamViewer log files for more details!'
            501 = 'The current user was denied access'
            502 = 'The download of the custom configuration timed out'
            503 = 'Invalid Module'
            504 = 'Restart of the GUI failed'
            505 = 'Custom configuration failed. See the TeamViewer log files for more details and check if the custom configuration id is still valid.'
            506 = 'Removal of custom configuration failed. See the TeamViewer log files for more details!'
        }
    }
    Process {
        if ($exitCode) {
            if ($exitCodeMessages.ContainsKey($exitCode)) {
                Write-Output $exitCodeMessages[$exitCode]
            }
            else {
                Write-Output "Unexpected error code: $exitCode. Check TeamViewer documentation!"
            }
        }
        elseif ($exitCode -eq 0) {
            Write-Output $exitCodeMessages[$exitCode]
        }
    }
}



function Resolve-TeamViewerContactId {
    param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        [object]
        $Contact
    )
    Process {
        if ($Contact.PSObject.TypeNames -contains 'TeamViewerPS.Contact') {
            return $Contact.Id
        }
        elseif ($Contact -is [string]) {
            if ($Contact -notmatch 'c[0-9]+') {
                throw "Invalid contact identifier '$Contact'. String must be a contact ID in the form 'c123456789'."
            }
            return $Contact
        }
        else {
            throw "Invalid contact identifier '$Contact'. Must be either a [TeamViewerPS.Contact] or [string]."
        }
    }
}



function Resolve-TeamViewerDeviceId {
    param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        [object]
        $Device
    )
    Process {
        if ($Device.PSObject.TypeNames -contains 'TeamViewerPS.Device') {
            return $Device.Id
        }
        elseif ($Device -is [string]) {
            if ($Device -notmatch 'd[0-9]+') {
                throw "Invalid device identifier '$Device'. String must be a device ID in the form 'd123456789'."
            }
            return $Device
        }
        else {
            throw "Invalid device identifier '$Device'. Must be either a [TeamViewerPS.Device] or [string]."
        }
    }
}



function Resolve-TeamViewerGroupId {
    param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        [object]
        $Group
    )
    Process {
        if ($Group.PSObject.TypeNames -contains 'TeamViewerPS.Group') {
            return $Group.Id
        }
        elseif ($Group -is [string]) {
            if ($Group -notmatch 'g[0-9]+') {
                throw "Invalid group identifier '$Group'. String must be a group ID in the form 'g123456789'."
            }
            return $Group
        }
        else {
            throw "Invalid group identifier '$Group'. Must be either a [TeamViewerPS.Group] or [string]."
        }
    }
}



function Resolve-TeamViewerLanguage {
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [object]
        $InputObject
    )
    Process {
        $supportedLanguages = @(
            'bg', 'cs', 'da', 'de', 'el', 'en', 'es', 'fi', 'fr', 'hr', 'hu', 'id', 'it', 'ja',
            'ko', 'lt', 'nl', 'no', 'pl', 'pt', 'ro', 'ru', 'sk', 'sr', 'sv', 'th', 'tr', 'uk',
            'vi', 'zh_CN', 'zh_TW', 'auto')

        $language = $InputObject
        if ($InputObject -is [cultureinfo]) {
            $language = switch ($InputObject.Name) {
                'zh-CN' { 'zh_CN' }
                'zh-TW' { 'zh_TW' }
                default { $InputObject.TwoLetterISOLanguageName }
            }
        }

        if ($supportedLanguages -notcontains $language) {
            throw "Invalid culture '$language'. Supported languages are: $supportedLanguages"
        }

        return $language
    }
}



function Resolve-TeamViewerManagedDeviceId {
    param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        [object]
        $ManagedDevice
    )
    Process {
        if ($ManagedDevice.PSObject.TypeNames -contains 'TeamViewerPS.ManagedDevice') {
            return [guid]$ManagedDevice.Id
        }
        elseif ($ManagedDevice -is [string]) {
            return [guid]$ManagedDevice
        }
        elseif ($ManagedDevice -is [guid]) {
            return $ManagedDevice
        }
        else {
            throw "Invalid managed device identifier '$ManagedDevice'. Must be either a [TeamViewerPS.ManagedDevice], [guid] or [string]."
        }
    }
}



function Resolve-TeamViewerManagedGroupId {
    param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        [object]
        $ManagedGroup
    )
    Process {
        if ($ManagedGroup.PSObject.TypeNames -contains 'TeamViewerPS.ManagedGroup') {
            return [guid]$ManagedGroup.Id
        }
        elseif ($ManagedGroup -is [string]) {
            return [guid]$ManagedGroup
        }
        elseif ($ManagedGroup -is [guid]) {
            return $ManagedGroup
        }
        else {
            throw "Invalid managed group identifier '$ManagedGroup'. Must be either a [TeamViewerPS.ManagedGroup], [guid] or [string]."
        }
    }
}



function Resolve-TeamViewerManagerId {
    param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        [object]
        $Manager
    )
    Process {
        if ($Manager.PSObject.TypeNames -contains 'TeamViewerPS.Manager') {
            return [guid]$Manager.Id
        }
        elseif ($Manager -is [string]) {
            return [guid]$Manager
        }
        elseif ($Manager -is [guid]) {
            return $Manager
        }
        else {
            throw "Invalid manager identifier '$Manager'. Must be either a [TeamViewerPS.Manager], [guid] or [string]."
        }
    }
}



function Resolve-TeamViewerPolicyId {
    param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        [object]
        $Policy,

        [Parameter()]
        [switch]
        $AllowNone,

        [Parameter()]
        [switch]
        $AllowInherit
    )
    Process {
        if ($Policy.PSObject.TypeNames -contains 'TeamViewerPS.Policy') {
            return [guid]$Policy.Id
        }
        elseif ($Policy -is [string]) {
            if ($Policy -eq 'none' -And $AllowNone) {
                return 'none'
            }
            elseif ($Policy -eq 'inherit' -And $AllowInherit) {
                return 'inherit'
            }
            else {
                return [guid]$Policy
            }
        }
        elseif ($Policy -is [guid]) {
            return $Policy
        }
        else {
            throw "Invalid policy identifier '$Policy'. Must be either a [TeamViewerPS.Policy], [guid] or [string]."
        }
    }
}



function Resolve-TeamViewerSsoDomainId {
    param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        [object]
        $Domain
    )
    Process {
        if ($Domain.PSObject.TypeNames -contains 'TeamViewerPS.SsoDomain') {
            return [guid]$Domain.Id
        }
        elseif ($Domain -is [string]) {
            return [guid]$Domain
        }
        elseif ($Domain -is [guid]) {
            return $Domain
        }
        else {
            throw "Invalid SSO domain identifier '$Domain'. Must be either a [TeamViewerPS.SsoDomain], [guid] or [string]."
        }
    }
}



function Resolve-TeamViewerUserEmail {
    param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $false)]
        [object]
        $User
    )
    Process {
        if (!$User) {
            return $null
        }
        elseif ($User.PSObject.TypeNames -contains 'TeamViewerPS.User') {
            return $User.Email
        }
        elseif ($User -is [string]) {
            return $User
        }
        else {
            throw "Invalid user email '$User'. Must be either a [TeamViewerPS.User] or [string]."
        }
    }
}



function Resolve-TeamViewerUserGroupId {
    param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        [object]
        $UserGroup
    )
    Process {
        if ($UserGroup.PSObject.TypeNames -contains 'TeamViewerPS.UserGroup') {
            return [UInt64]$UserGroup.Id
        }
        elseif ($UserGroup -is [string]) {
            return [UInt64]$UserGroup
        }
        elseif ($UserGroup -is [UInt64] -or $UserGroup -is [Int64] -or $UserGroup -is [int]) {
            return [UInt64]$UserGroup
        }
        else {
            throw "Invalid user group identifier '$UserGroup'. Must be either a [TeamViewerPS.UserGroup], [UInt64], [Int64] or [string]."
        }
    }
}



function Resolve-TeamViewerUserGroupMemberMemberId {
    param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        [object]
        $UserGroupMember
    )
    Process {
        if ($UserGroupMember.PSObject.TypeNames -contains 'TeamViewerPS.UserGroupMember') {
            return $UserGroupMember.AccountId
        }
        elseif ($UserGroupMember -match 'u[0-9]+') {
            return $UserGroupMember
        }
        elseif ($UserGroupMember -is [string]) {
            return [int]$UserGroupMember
        }
        elseif ($UserGroupMember -is [int]) {
            return $UserGroupMember
        }
        else {
            throw "Invalid user group identifier '$UserGroupMember'. Must be either a [TeamViewerPS.UserGroupMember],[TeamViewerPS.User] or [int] ."
        }
    }
}



function Resolve-TeamViewerUserId {
    param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        [object]
        $User
    )
    Process {
        if ($User.PSObject.TypeNames -contains 'TeamViewerPS.User') {
            return $User.Id
        }
        elseif ($User -is [string]) {
            if ($User -notmatch 'u[0-9]+') {
                throw "Invalid user identifier '$User'. String must be a user ID in the form 'u123456789'."
            }
            return $User
        }
        else {
            throw "Invalid user identifier '$User'. Must be either a [TeamViewerPS.User] or [string]."
        }
    }
}




function Resolve-TeamViewerUserRoleId {
    param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        [object]
        $UserRole
    )
    Process {
        if ($UserRole.PSObject.TypeNames -contains 'TeamViewerPS.UserRole') {
            return [string]$UserRole.RoleID
        }
        elseif ($UserRole -match '^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$') {
            return [string]$UserRole
        }
        else {
            throw "Invalid role group identifier '$UserRole'. Must be either a [TeamViewerPS.UserRole] or [UUID] "
        }
    }
}



$hasTestNetConnection = [bool](Get-Command Test-NetConnection -ErrorAction SilentlyContinue)
$hasTestConnection = [bool](Get-Command Test-Connection -ErrorAction SilentlyContinue | Where-Object { $_.Version -ge 5.1 })

function Test-TcpConnection {
    param(
        [Parameter(Mandatory = $true)]
        [string]
        $Hostname,

        [Parameter(Mandatory = $true)]
        [int]
        $Port
    )

    if (-Not $hasTestNetConnection -And -Not $hasTestConnection) {
        throw "No suitable cmdlet found for testing the TeamViewer network connectivity."
    }

    $oldProgressPreference = $global:ProgressPreference
    $global:ProgressPreference = 'SilentlyContinue'

    if ($hasTestNetConnection) {
        Test-NetConnection -ComputerName $Hostname -Port $Port -InformationLevel Quiet -WarningAction SilentlyContinue
    }
    elseif ($hasTestConnection) {
        Test-Connection -TargetName $Hostname -TcpPort $Port -Quiet -WarningAction SilentlyContinue
    }
    else {
        $false
    }

    $global:ProgressPreference = $oldProgressPreference
}



function Test-TeamViewer32on64 {
    if (![Environment]::Is64BitOperatingSystem) {
        return $false
    }
    $registryKey = Get-TeamViewerRegKeyPath -Variant WOW6432
    if (!(Test-Path $registryKey)) {
        return $false
    }
    try {
        $installationDirectory = (Get-Item $registryKey).GetValue('InstallationDirectory')
        $binaryPath = Join-Path $installationDirectory 'TeamViewer.exe'
        return Test-Path $binaryPath
    }
    catch {
        return $false
    }
}



function Add-TeamViewerAssignment {
    param(
        [Parameter(Mandatory = $true)]
        [object]
        $AssignmentId,

        [string]
        $DeviceAlias,

        [int]
        $Retries
    )


    if (Test-TeamViewerInstallation) {
        $OS = Get-OperatingSystem
        $CurrentDirectory = Get-Location
        $installationDirectory = Get-TeamViewerInstallationDirectory
        Set-Location $installationDirectory
        $CurrentVersion = Get-TeamViewerVersion
        $VersionTable = $CurrentVersion.split('.')
        if ($OS -eq 'Windows') {
            $cmd = "assignment --id $AssignmentId"
            $FilePath = 'TeamViewer.exe'
        }
        elseif ($OS -eq 'Linux') {
            $cmd = "teamviewer assignment --id $AssignmentId"
            $FilePath = 'sudo'
        }

        if ($DeviceAlias) {
            if (($VersionTable[0] -eq 15 -and $VersionTable[1] -ge 44) -or $VersionTable[0] -gt 15) {
                $cmd += " --device-alias=$DeviceAlias"
            }
            else {
                Write-Error "Current TeamViewer Version: $CurrentVersion does not support the usage of alias. Please update to the latest version."
                Set-Location $CurrentDirectory
                exit
            }
        }
        if ($Retries) {
            $cmd += " --retries=$Retries"
        }
        $process = Start-Process -FilePath $FilePath -ArgumentList $cmd -Wait -PassThru
        $process.ExitCode | Resolve-AssignmentErrorCode
        Set-Location $CurrentDirectory
    }
    else {
        Write-Output 'TeamViewer is not installed.'
    }
}





Function Add-TeamViewerCustomization {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'ById')]
        [object]
        $Id,

        [Parameter(Mandatory = $true, ParameterSetName = 'ByPath')]
        [object]
        $Path,

        [switch]
        $RestartGUI,

        [switch]
        $RemoveExisting
    )

    if (Get-OperatingSystem -eq 'Windows') {
        if (Test-TeamViewerInstallation) {
            $installationDirectory = Get-TeamViewerInstallationDirectory
            $currentDirectory = Get-Location
            Set-Location $installationDirectory
            $cmd = 'customize'
            if ($Id) {
                $cmd += " --id $Id"
            }
            elseif ($Path) {
                $cmd += " --path $Path"
            }
            if ($RemoveExisting) {
                $cmd += ' --remove'
            }
            if ($RestartGUI) {
                $cmd += ' --restart-gui'
            }
            $process = Start-Process -FilePath TeamViewer.exe -ArgumentList $cmd -Wait -PassThru
            $process.ExitCode | Resolve-CustomizationErrorCode
            Set-Location $currentDirectory
        }
        else {
            Write-Error 'TeamViewer is not installed'
        }
    }
    else {
        Write-Error 'Customization is currently supported only on Windows.'
    }
}



function Add-TeamViewerManagedDevice {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedDeviceId } )]
        [Alias("DeviceId")]
        [object]
        $Device,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedGroupId } )]
        [Alias("GroupId")]
        [object]
        $Group
    )

    $deviceId = $Device | Resolve-TeamViewerManagedDeviceId
    $groupId = $Group | Resolve-TeamViewerManagedGroupId
    $resourceUri = "$(Get-TeamViewerApiUri)/managed/groups/$groupId/devices"

    $body = @{
        id = $deviceId
    }

    if ($PSCmdlet.ShouldProcess($deviceId, "Add device to managed group")) {
        Invoke-TeamViewerRestMethod `
            -ApiToken $ApiToken `
            -Uri $resourceUri `
            -Method Post `
            -ContentType "application/json; charset=utf-8" `
            -Body ([System.Text.Encoding]::UTF8.GetBytes(($body | ConvertTo-Json))) `
            -WriteErrorTo $PSCmdlet | `
            Out-Null
    }
}



function Add-TeamViewerManager {
    [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'Device_ByAccountId')]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true, ParameterSetName = 'Device_ByAccountId')]
        [Parameter(Mandatory = $true, ParameterSetName = 'Group_ByAccountId')]
        [string]
        $AccountId,

        [Parameter(Mandatory = $true, ParameterSetName = 'Device_ByManagerId')]
        [Parameter(Mandatory = $true, ParameterSetName = 'Group_ByManagerId')]
        [ValidateScript( { $_ | Resolve-TeamViewerManagerId } )]
        [Alias("ManagerId")]
        [object]
        $Manager,

        [Parameter(Mandatory = $true, ParameterSetName = 'Device_ByUserObject')]
        [Parameter(Mandatory = $true, ParameterSetName = 'Group_ByUserObject')]
        [ValidateScript( { $_ | Resolve-TeamViewerUserId } )]
        [object]
        $User,

        [Parameter(Mandatory = $true, ParameterSetName = 'Group_ByUserGroupId')]
        [Parameter(Mandatory = $true, ParameterSetName = 'Device_ByUserGroupId')]
        [ValidateScript( { $_ | Resolve-TeamViewerUserGroupId })]
        [Alias('UserGroupId')]
        [object]
        $UserGroup,

        [Parameter(Mandatory = $true, ParameterSetName = 'Group_ByAccountId')]
        [Parameter(Mandatory = $true, ParameterSetName = 'Group_ByManagerId')]
        [Parameter(Mandatory = $true, ParameterSetName = 'Group_ByUserObject')]
        [Parameter(Mandatory = $true, ParameterSetName = 'Group_ByUserGroupId')]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedGroupId } )]
        [Alias("GroupId")]
        [object]
        $Group,

        [Parameter(Mandatory = $true, ParameterSetName = 'Device_ByAccountId')]
        [Parameter(Mandatory = $true, ParameterSetName = 'Device_ByManagerId')]
        [Parameter(Mandatory = $true, ParameterSetName = 'Device_ByUserObject')]
        [Parameter(Mandatory = $true, ParameterSetName = 'Device_ByUserGroupId')]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedDeviceId } )]
        [Alias("DeviceId")]
        [object]
        $Device,

        [Parameter()]
        [AllowEmptyCollection()]
        [string[]]
        $Permissions
    )

    $resourceUri = $null
    switch -Wildcard ($PSCmdlet.ParameterSetName) {
        'Device*' {
            $deviceId = $Device | Resolve-TeamViewerManagedDeviceId
            $resourceUri = "$(Get-TeamViewerApiUri)/managed/devices/$deviceId/managers"
            $processMessage = "Add manager to managed device"
        }
        'Group*' {
            $groupId = $Group | Resolve-TeamViewerManagedGroupId
            $resourceUri = "$(Get-TeamViewerApiUri)/managed/groups/$groupId/managers"
            $processMessage = "Add manager to managed group"
        }
    }

    $body = @{}
    switch -Wildcard ($PSCmdlet.ParameterSetName) {
        '*ByAccountId' {
            $body["accountId"] = $AccountId.TrimStart('u')
        }
        '*ByManagerId' {
            $body["id"] = $Manager | Resolve-TeamViewerManagerId
        }
        '*ByUserObject' {
            $body["accountId"] = ( $User | Resolve-TeamViewerUserId ).TrimStart('u')
        }
        '*ByUserGroupId' {
            $body["usergroupId"] = $UserGroup | Resolve-TeamViewerUserGroupId
        }
    }

    if ($Permissions) {
        $body["permissions"] = @($Permissions)
    }
    else {
        $body["permissions"] = @()
    }

    if ($PSCmdlet.ShouldProcess($managerId, $processMessage)) {
        Invoke-TeamViewerRestMethod `
            -ApiToken $ApiToken `
            -Uri $resourceUri `
            -Method Post `
            -ContentType "application/json; charset=utf-8" `
            -Body ([System.Text.Encoding]::UTF8.GetBytes((ConvertTo-Json -InputObject @($body)))) `
            -WriteErrorTo $PSCmdlet | `
            Out-Null
    }
}



function Add-TeamViewerRoleToAccount {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerUserRoleId } )]
        [Alias('UserRole')]
        [object]
        $UserRoleId,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('Id', 'UserIds')]
        [string[]]
        $Accounts
    )

    Begin {
        $id = $UserRoleId | Resolve-TeamViewerUserRoleId
        $null = $ApiToken
        $resourceUri = "$(Get-TeamViewerApiUri)/userroles/assign/account"
        $AccountsToAdd = @()
        $body = @{
            UserIds    = @()
            UserRoleId = $id
        }
        function Invoke-TeamViewerRestMethodInternal {
            $result = Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $resourceUri `
                -Method Post `
                -ContentType 'application/json; charset=utf-8' `
                -Body ([System.Text.Encoding]::UTF8.GetBytes(($body | ConvertTo-Json))) `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop
            Write-Output ($result)
        }
    }


    Process {
        if ($PSCmdlet.ShouldProcess($Accounts, 'Assign Account to Role')) {
            if (($Accounts -notmatch 'u[0-9]+') -and ($Accounts -match '[0-9]+')) {
                $Accounts = $Accounts | ForEach-Object { $_.Insert(0, 'u') }
            }
            foreach ($Account in $Accounts) {
                $AccountsToAdd += $Account
                $body.UserIds = @($AccountsToAdd)
            }
        }
        if ($AccountsToAdd.Length -eq 100) {
            Invoke-TeamViewerRestMethodInternal
            $AccountsToAdd = @()
        }
    }
    End {
        if ($AccountsToAdd.Length -gt 0) {
            Invoke-TeamViewerRestMethodInternal
        }
    }
}




function Add-TeamViewerRoleToUserGroup {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerUserRoleId } )]
        [Alias('UserRoleId')]
        [object]
        $UserRole,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerUserGroupId } )]
        [Alias('UserGroupId')]
        [Alias('Id')]
        [object]
        $UserGroup
    )

    Begin {
        $RoleId = $UserRole | Resolve-TeamViewerUserRoleId
        $null = $ApiToken
        $resourceUri = "$(Get-TeamViewerApiUri)/userroles/assign/usergroup"
        $body = @{
            UserRoleId  = $RoleId
            UserGroupId = $UserGroup

        }
    }


    Process {
        if ($PSCmdlet.ShouldProcess($UserGroup, 'Assign Role to User Group')) {
            $result = Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $resourceUri `
                -Method Post `
                -ContentType 'application/json; charset=utf-8' `
                -Body ([System.Text.Encoding]::UTF8.GetBytes(($body | ConvertTo-Json))) `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop
            Write-Output ($result)
        }
    }
}



function Add-TeamViewerSsoExclusion {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerSsoDomainId } )]
        [Alias("Domain")]
        [object]
        $DomainId,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string[]]
        $Email
    )
    Begin {
        $id = $DomainId | Resolve-TeamViewerSsoDomainId
        $resourceUri = "$(Get-TeamViewerApiUri)/ssoDomain/$id/exclusion"
        $emailsToAdd = @()
        $null = $ApiToken   # https://github.com/PowerShell/PSScriptAnalyzer/issues/1472

        function Invoke-RequestInternal {
            $body = @{
                emails = @($emailsToAdd)
            }
            Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $resourceUri `
                -Method Post `
                -ContentType "application/json; charset=utf-8" `
                -Body ([System.Text.Encoding]::UTF8.GetBytes(($body | ConvertTo-Json))) `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop | `
                Out-Null
        }
    }
    Process {
        if ($PSCmdlet.ShouldProcess($Email, "Add SSO exclusion")) {
            $emailsToAdd += $Email
        }
        if ($emailsToAdd.Length -eq 100) {
            Invoke-RequestInternal
            $emailsToAdd = @()
        }
    }
    End {
        if ($emailsToAdd.Length -gt 0) {
            Invoke-RequestInternal
        }
    }
}



function Add-TeamViewerUserGroupMember {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerUserGroupId } )]
        [Alias('UserGroupId')]
        [Alias('Id')]
        [object]
        $UserGroup,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [object[]]
        [Alias('UserGroupMemberId')]
        [Alias('UserGroupMember')]
        [Alias('MemberId')]
        [Alias('UserId')]
        [Alias('User')]
        $Member
    )

    Begin {
        $id = $UserGroup | Resolve-TeamViewerUserGroupId
        $resourceUri = "$(Get-TeamViewerApiUri)/usergroups/$id/members"
        $membersToAdd = @()
        $body = @()
        $null = $ApiToken # https://github.com/PowerShell/PSScriptAnalyzer/issues/1472

        function Invoke-TeamViewerRestMethodInternal {
            $result = Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $resourceUri `
                -Method Post `
                -ContentType 'application/json; charset=utf-8' `
                -Body ([System.Text.Encoding]::UTF8.GetBytes(($body))) `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop

            Write-Output ($result | ConvertTo-TeamViewerUserGroupMember)
        }
    }

    Process {
        # when members are provided as pipeline input, each member is provided as a separate statement,
        # thus the members should be combined into one array in order to send a single request.
        if ($PSCmdlet.ShouldProcess($Member, 'Add user groups member')) {
            if ($Member -notmatch 'u[0-9]+') {
                ForEach-Object {
                    $Member = [int[]]$Member
                }
            }
            else {
                ForEach-Object {
                    $Member = [int[]]$Member.trim('u')
                }
            }
            if ($Member -isnot [array]) {
                $membersToAdd = @([UInt32]$Member)
            }
            else {
                $membersToAdd += [UInt32[]]$Member
            }
            $payload = $membersToAdd -join ', '
            $body = "[$payload]"
        }

        # WebAPI accepts a maximum of 100 accounts. Thus we send a request and reset the `membersToAdd`
        # in order to accept more members
        if ($membersToAdd.Length -eq 100) {
            Invoke-TeamViewerRestMethodInternal
            $membersToAdd = @()
        }
    }

    End {
        # A request needs to be sent if there were less than 100 members
        if ($membersToAdd.Length -gt 0) {
            Invoke-TeamViewerRestMethodInternal
        }
    }
}



function Connect-TeamViewerApi {
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken
    )

    if (Invoke-TeamViewerPing -ApiToken $ApiToken) {
        $global:PSDefaultParameterValues["*-Teamviewer*:ApiToken"] = $ApiToken
    }
}


function Disconnect-TeamViewerApi {
    $global:PSDefaultParameterValues.Remove("*-Teamviewer*:ApiToken")
}


function Export-TeamViewerSystemInformation {
    param(
        [Parameter(ValueFromPipeline = $true)]
        [string]
        $TargetDirectory
    )
    Process {
        if (Test-TeamViewerInstallation ) {
            if (Get-OperatingSystem -eq 'Windows') {
                $Temp = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), [System.Guid]::NewGuid().ToString())
                $CurrentDirectory = Get-Location
                $Temp | Get-TSCDirectoryFile
                $Temp | Get-InstalledSoftware
                $Temp | Get-IpConfig
                $Temp | Get-MSInfo32
                $Temp | Get-HostFile
                $Temp | Get-NSLookUpData
                $Temp | Get-RouteTable
                $Temp | Get-RegistryPath
                $ClientID = Get-ClientId
                $ZipFileName = 'TV_SC_' + $ClientID + '_WINPS.zip'
                $ZipPath = Join-Path -Path "$Temp\Data" -ChildPath $ZipFileName
                Compress-Archive -Path $Temp\* -DestinationPath $ZipPath -Force
                if ($TargetDirectory -and (Test-Path $TargetDirectory)) {
                    Copy-Item -Path $ZipPath -Destination $TargetDirectory -Force
                }
                else {
                    Copy-Item -Path $ZipPath -Destination $CurrentDirectory -Force
                }
            }
            else {
                Write-Error 'Currently this functionality is supported only on Windows.'
            }
        }
        else {
            Write-Error 'TeamViewer is not installed.'
        }
    }
}



function Get-TeamViewerAccount {
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken
    )

    $resourceUri = "$(Get-TeamViewerApiUri)/account"

    $response = Invoke-TeamViewerRestMethod `
        -ApiToken $ApiToken `
        -Uri $resourceUri `
        -Method Get `
        -WriteErrorTo $PSCmdlet `
        -ErrorAction Stop
    Write-Output ($response | ConvertTo-TeamViewerAccount)
}



function Get-TeamViewerConnectionReport {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $false)]
        [string]
        $UserName,

        [Parameter(Mandatory = $false)]
        [ValidateScript( { $_ | Resolve-TeamViewerUserId } )]
        [Alias("User")]
        [object]
        $UserId,

        [Parameter(Mandatory = $false)]
        [ValidateScript( { $_ | Resolve-TeamViewerGroupId } )]
        [Alias("Group")]
        [object]
        $GroupId,

        [Parameter(Mandatory = $false)]
        [string]
        $DeviceName,

        [Parameter(Mandatory = $false)]
        [int]
        $DeviceId,

        [Parameter(Mandatory = $false)]
        [switch]
        $WithSessionCode,

        [Parameter(Mandatory = $false)]
        [switch]
        $WithoutSessionCode,

        [Parameter(Mandatory = $false)]
        [string]
        $SessionCode,

        [Parameter(Mandatory = $false)]
        [TeamViewerConnectionReportSessionType]
        $SupportSessionType,

        [Parameter(Mandatory = $true, ParameterSetName = "AbsoluteDates")]
        [DateTime]
        $StartDate,

        [Parameter(Mandatory = $false, ParameterSetName = "AbsoluteDates")]
        [Parameter(Mandatory = $false, ParameterSetName = "RelativeDates")]
        [DateTime]
        $EndDate = (Get-Date),

        [Parameter(Mandatory = $false, ParameterSetName = "RelativeDates")]
        [ValidateRange(0, 12)]
        [int]
        $Months,

        [Parameter(Mandatory = $false, ParameterSetName = "RelativeDates")]
        [ValidateRange(0, 31)]
        [int]
        $Days,

        [Parameter(Mandatory = $false, ParameterSetName = "RelativeDates")]
        [ValidateRange(0, 24)]
        [int]
        $Hours,

        [Parameter(Mandatory = $false, ParameterSetName = "RelativeDates")]
        [ValidateRange(0, 60)]
        [int]
        $Minutes,

        [Parameter(Mandatory = $false)]
        [ValidateRange(1, [int]::MaxValue)]
        [int]
        $Limit
    )

    $resourceUri = "$(Get-TeamViewerApiUri)/reports/connections";

    $parameters = @{}

    if ($PSCmdlet.ParameterSetName -Eq 'RelativeDates') {
        $StartDate = $EndDate.AddMonths(-1 * $Months).AddDays(-1 * $Days).AddHours(-1 * $Hours).AddMinutes(-1 * $Minutes)
    }
    if ($StartDate -And $EndDate -And $StartDate -lt $EndDate) {
        $parameters.from_date = $StartDate.ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
        $parameters.to_date = $EndDate.ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
    }

    if ($UserName) {
        $parameters.username = $UserName
    }

    if ($UserId) {
        $parameters.userid = $UserId | Resolve-TeamViewerUserId
    }

    if ($DeviceName) {
        $parameters.devicename = $DeviceName
    }

    if ($DeviceId) {
        $parameters.deviceid = $DeviceId
    }

    if ($GroupId) {
        $parameters.groupid = $GroupId | Resolve-TeamViewerGroupId
    }

    if ($WithSessionCode -And !$WithoutSessionCode) {
        $parameters.has_code = $true
    }
    elseif ($WithoutSessionCode -And !$WithSessionCode) {
        $parameters.has_code = $false
    }

    if ($SessionCode) {
        $parameters.session_code = $SessionCode
    }

    if ($SupportSessionType) {
        $parameters.support_session_type = [int]$SupportSessionType
    }

    $remaining = $Limit
    do {
        $response = Invoke-TeamViewerRestMethod `
            -ApiToken $ApiToken `
            -Uri $resourceUri `
            -Method Get `
            -Body $parameters `
            -WriteErrorTo $PSCmdlet `
            -ErrorAction Stop
        $results = ($response.records | ConvertTo-TeamViewerConnectionReport)
        if ($Limit) {
            Write-Output ($results | Select-Object -First $remaining)
            $remaining = $remaining - @($results).Count
        }
        else {
            Write-Output $results
        }
        $parameters.offset_id = $response.next_offset
    } while ($parameters.offset_id -And (!$Limit -Or $remaining -gt 0))
}



function Get-TeamViewerContact {
    [CmdletBinding(DefaultParameterSetName = "FilteredList")]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(ParameterSetName = "ByContactId")]
        [ValidateScript( { $_ | Resolve-TeamViewerContactId } )]
        [Alias("ContactId")]
        [string]
        $Id,

        [Parameter(ParameterSetName = "FilteredList")]
        [Alias("PartialName")]
        [string]
        $Name,

        [Parameter(ParameterSetName = "FilteredList")]
        [ValidateSet('Online', 'Busy', 'Away', 'Offline')]
        [string]
        $FilterOnlineState,

        [Parameter(ParameterSetName = "FilteredList")]
        [ValidateScript( { $_ | Resolve-TeamViewerGroupId } )]
        [Alias("GroupId")]
        [object]
        $Group
    )

    $resourceUri = "$(Get-TeamViewerApiUri)/contacts";
    $parameters = @{ }

    switch ($PsCmdlet.ParameterSetName) {
        'ByContactId' {
            $resourceUri += "/$Id"
            $parameters = $null
        }
        'FilteredList' {
            if ($Name) {
                $parameters['name'] = $Name
            }
            if ($FilterOnlineState) {
                $parameters['online_state'] = $FilterOnlineState.ToLower()
            }
            if ($Group) {
                $groupId = $Group | Resolve-TeamViewerGroupId
                $parameters['groupid'] = $groupId
            }
        }
    }

    $response = Invoke-TeamViewerRestMethod `
        -ApiToken $ApiToken `
        -Uri $resourceUri `
        -Method Get `
        -Body $parameters `
        -WriteErrorTo $PSCmdlet `
        -ErrorAction Stop

    Write-Output ($response.contacts | ConvertTo-TeamViewerContact)
}



function Get-TeamViewerCustomModuleId {

    if (Test-TeamViewerinstallation) {
        $fileName = 'TeamViewer.json'
        $installationDirectory = Get-TeamViewerInstallationDirectory
        $filePath = Join-Path -Path $installationDirectory -ChildPath $fileName
        if (Test-Path -Path $filePath) {
            $jsonContent = Get-Content -Path $FilePath -Raw
            $jsonObject = ConvertFrom-Json $jsonContent
            if ($jsonObject.id) {
                return $jsonObject.id
            }
        }
        else {
            Write-Error 'Custom module Id cannot be found. Check if customization is applied.'
        }
    }
    else {
        Write-Error 'TeamViewer is not installed'
    }

}



function Get-TeamViewerDevice {
    [CmdletBinding(DefaultParameterSetName = "FilteredList")]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(ParameterSetName = "ByDeviceId")]
        [ValidateScript( { $_ | Resolve-TeamViewerDeviceId } )]
        [Alias("DeviceId")]
        [string]
        $Id,

        [Parameter(ParameterSetName = "FilteredList")]
        [int]
        $TeamViewerId,

        [Parameter(ParameterSetName = "FilteredList")]
        [ValidateSet('Online', 'Busy', 'Away', 'Offline')]
        [string]
        $FilterOnlineState,

        [Parameter(ParameterSetName = "FilteredList")]
        [ValidateScript( { $_ | Resolve-TeamViewerGroupId } )]
        [Alias("GroupId")]
        [object]
        $Group
    )

    $resourceUri = "$(Get-TeamViewerApiUri)/devices";
    $parameters = @{ }

    switch ($PsCmdlet.ParameterSetName) {
        'ByDeviceId' {
            $resourceUri += "/$Id"
            $parameters = $null
        }
        'FilteredList' {
            if ($TeamViewerId) {
                $parameters['remotecontrol_id'] = "r$TeamViewerId"
            }
            if ($FilterOnlineState) {
                $parameters['online_state'] = $FilterOnlineState.ToLower()
            }
            if ($Group) {
                $groupId = $Group | Resolve-TeamViewerGroupId
                $parameters['groupid'] = $groupId
            }
        }
    }

    $response = Invoke-TeamViewerRestMethod `
        -ApiToken $ApiToken `
        -Uri $resourceUri `
        -Method Get `
        -Body $parameters `
        -WriteErrorTo $PSCmdlet `
        -ErrorAction Stop

    Write-Output ($response.devices | ConvertTo-TeamViewerDevice)
}



function Get-TeamViewerEventLog {
    [CmdletBinding(DefaultParameterSetName = "RelativeDates")]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true, ParameterSetName = "AbsoluteDates")]
        [DateTime]
        $StartDate,

        [Parameter(Mandatory = $false, ParameterSetName = "AbsoluteDates")]
        [Parameter(Mandatory = $false, ParameterSetName = "RelativeDates")]
        [DateTime]
        $EndDate = (Get-Date),

        [Parameter(Mandatory = $false, ParameterSetName = "RelativeDates")]
        [ValidateRange(0, 12)]
        [int]
        $Months,

        [Parameter(Mandatory = $false, ParameterSetName = "RelativeDates")]
        [ValidateRange(0, 31)]
        [int]
        $Days,

        [Parameter(Mandatory = $false, ParameterSetName = "RelativeDates")]
        [ValidateRange(0, 24)]
        [int]
        $Hours,

        [Parameter(Mandatory = $false, ParameterSetName = "RelativeDates")]
        [ValidateRange(0, 60)]
        [int]
        $Minutes,

        [Parameter(Mandatory = $false)]
        [int]
        $Limit,

        [Parameter(Mandatory = $false)]
        [ArgumentCompleter( {
                param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
                $null = @($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
                @(
                    'AddRemoteWorkerDevice',
                    'ChangedDisabledRemoteInput',
                    'ChangedShowBlackScreen',
                    'CompanyAddressBookDisabled',
                    'CompanyAddressBookEnabled',
                    'CompanyAddressBookMembersHid',
                    'CompanyAddressBookMembersUnhid'
                    'ConditionalAccessBlockMeetingStateChanged',
                    'ConditionalAccessDirectoryGroupAdded',
                    'ConditionalAccessDirectoryGroupDeleted',
                    'ConditionalAccessDirectoryGroupMembersAdded',
                    'ConditionalAccessDirectoryGroupMembersDeleted',
                    'ConditionalAccessRuleAdded',
                    'ConditionalAccessRuleDeleted',
                    'ConditionalAccessRuleModified',
                    'ConditionalAccessRuleVerificationStateChanged',
                    'CreateCustomHost',
                    'DeleteCustomHost',
                    'EditOwnProfile',
                    'EditTFAUsage',
                    'EditUserPermissions',
                    'EditUserProperties',
                    'EmailConfirmed',
                    'EndedRecording',
                    'EndedSession',
                    'GroupAdded',
                    'GroupDeleted',
                    'GroupShared',
                    'GroupUpdated',
                    'IncomingSession',
                    'JoinCompany',
                    'JoinedSession',
                    'LeftSession',
                    'ParticipantJoinedSession',
                    'ParticipantLeftSession',
                    'PausedRecording',
                    'PolicyAdded',
                    'PolicyDeleted',
                    'PolicyUpdated',
                    'ReceivedDisabledLocalInput',
                    'ReceivedFile',
                    'ReceivedShowBlackScreen',
                    'RemoveRemoteWorkerDevice',
                    'ResumedRecording',
                    'ScriptTokenAdded',
                    'ScriptTokenDeleted',
                    'ScriptTokenUpdated',
                    'SentFile',
                    'StartedRecording',
                    'StartedSession',
                    'SwitchedSides',
                    'UpdateCustomHost',
                    'UserCreated',
                    'UserDeleted',
                    'UserGroupCreated',
                    'UserGroupDeleted',
                    'UserGroupMembersAdded',
                    'UserGroupMembersRemoved',
                    'UserGroupUpdated',
                    'UserRemovedFromCompany'
                ) | Where-Object { $_ -like "$wordToComplete*" }
            } )]
        [string[]]
        $EventNames,

        [Parameter(Mandatory = $false)]
        [ArgumentCompleter( {
                param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
                $null = @($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
                @(
                    "CompanyAddressBook",
                    "CompanyAdministration",
                    "ConditionalAccess",
                    "CustomModules",
                    "GroupManagement",
                    "LicenseManagement",
                    "Policy",
                    "Session",
                    "UserGroups",
                    "UserProfile"
                ) | Where-Object { $_ -like "$wordToComplete*" }
            })]
        [string[]]
        $EventTypes,

        [Parameter(Mandatory = $false)]
        [ValidateScript( { $_ | Resolve-TeamViewerUserEmail } )]
        [Alias("Users")]
        [object[]]
        $AccountEmails,

        [Parameter(Mandatory = $false)]
        [string]
        $AffectedItem,

        [Parameter(Mandatory = $false)]
        [Alias("RemoteControlSession")]
        [guid]
        $RemoteControlSessionId
    )

    $resourceUri = "$(Get-TeamViewerApiUri)/EventLogging";

    $Limit = if ($Limit -lt 0) { $null } else { $Limit }

    if ($PSCmdlet.ParameterSetName -Eq 'RelativeDates') {
        $Hours = if (!$Months -And !$Days -And !$Hours -And !$Minutes) { 1 } else { $Hours }
        $StartDate = $EndDate.AddMonths(-1 * $Months).AddDays(-1 * $Days).AddHours(-1 * $Hours).AddMinutes(-1 * $Minutes)
    }

    $parameters = @{
        StartDate = $StartDate.ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
        EndDate   = $EndDate.ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
    }

    if ($EventNames) {
        $parameters.EventNames = $EventNames
    }
    if ($EventTypes) {
        $parameters.EventTypes = $EventTypes
    }
    if ($AccountEmails) {
        $parameters.AccountEmails = @($AccountEmails | Resolve-TeamViewerUserEmail)
    }
    if ($AffectedItem) {
        $parameters.AffectedItem = $AffectedItem
    }
    if ($RemoteControlSessionId) {
        $parameters.RCSessionGuid = $RemoteControlSessionId
    }

    $remaining = $Limit
    do {
        $response = Invoke-TeamViewerRestMethod `
            -ApiToken $ApiToken `
            -Uri $resourceUri `
            -Method Post `
            -ContentType "application/json; charset=utf-8" `
            -Body ([System.Text.Encoding]::UTF8.GetBytes(($parameters | ConvertTo-Json))) `
            -WriteErrorTo $PSCmdlet `
            -ErrorAction Stop
        $results = ($response.AuditEvents | ConvertTo-TeamViewerAuditEvent)
        if ($Limit) {
            Write-Output ($results | Select-Object -First $remaining)
            $remaining = $remaining - @($results).Count
        }
        else {
            Write-Output $results
        }
        $parameters.ContinuationToken = $response.ContinuationToken
    } while ($parameters.ContinuationToken -And (!$Limit -Or $remaining -gt 0))
}



function Get-TeamViewerGroup {
    [CmdletBinding(DefaultParameterSetName = "FilteredList")]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(ParameterSetName = "ByGroupId")]
        [Alias("GroupId")]
        [string]
        $Id,

        [Parameter(ParameterSetName = "FilteredList")]
        [Alias("PartialName")]
        [string]
        $Name,

        [Parameter(ParameterSetName = "FilteredList")]
        [ValidateSet('OnlyShared', 'OnlyNotShared')]
        [string]
        $FilterShared
    )

    $resourceUri = "$(Get-TeamViewerApiUri)/groups";
    $parameters = @{ }

    switch ($PsCmdlet.ParameterSetName) {
        'ByGroupId' {
            $resourceUri += "/$Id"
            $parameters = $null
        }
        'FilteredList' {
            if ($Name) {
                $parameters['name'] = $Name
            }
            switch ($FilterShared) {
                'OnlyShared' { $parameters['shared'] = $true }
                'OnlyNotShared' { $parameters['shared'] = $false }
            }
        }
    }

    $response = Invoke-TeamViewerRestMethod `
        -ApiToken $ApiToken `
        -Uri $resourceUri `
        -Method Get `
        -Body $parameters `
        -WriteErrorTo $PSCmdlet `
        -ErrorAction Stop

    if ($PsCmdlet.ParameterSetName -Eq 'ByGroupId') {
        Write-Output ($response | ConvertTo-TeamViewerGroup)
    }
    else {
        Write-Output ($response.groups | ConvertTo-TeamViewerGroup)
    }
}



function Get-TeamViewerId {
    if (Test-TeamViewerInstallation) {
        switch (Get-OperatingSystem) {
            'Windows' {
                Write-Output (Get-ItemPropertyValue -Path (Get-TeamViewerRegKeyPath) -Name 'ClientID')
            }
            'Linux' {
                Write-Output (Get-TeamViewerLinuxGlobalConfig -Name 'ClientID')
            }
        }
    }
}



function Get-TeamViewerInstallationDirectory {
    switch (Get-OperatingSystem) {
        'Windows' {
            $regKey = Get-TeamViewerRegKeyPath
            $installationDirectory = if (Test-Path $regKey) {
 (Get-Item $regKey).GetValue('InstallationDirectory')
            }
            if (
                $installationDirectory -And `
                (Test-Path "$installationDirectory/TeamViewer.exe")
            ) {
                return $installationDirectory
            }
        }
        'Linux' {
            if (
                (Test-Path '/opt/teamviewer/tv_bin/TeamViewer')
            ) {
                return '/opt/teamviewer/tv_bin/'
            }
        }
        default {
            Write-Error 'TeamViewer not installed'
        }
    }
}




function Get-TeamViewerLogFilePath {
    param(
        [switch]
        $OpenFile
    )

    if (Test-TeamViewerInstallation) {
        if (Get-OperatingSystem -eq 'Windows') {
            $SearchDirectories = Get-TSCSearchDirectory
            $LogFiles = New-Object System.Collections.ArrayList
            foreach ($Name in $SearchDirectories.Keys) {
                $SearchDirectory = $SearchDirectories[$Name]
                foreach ($Folder in $SearchDirectory) {
                    if (Test-Path -Path $Folder) {
                        $files = Get-ChildItem -Path $Folder -File -Recurse
                        foreach ($file in $files) {
                            if ($file.Name.EndsWith('.log')) {
                                $LogFiles.add($file.FullName) | Out-Null
                            }
                        }
                    }
                }
            }

            if ($OpenFile) {
                $LogFile = $host.ui.PromptForChoice('Select file', 'Choose file:', `
                    @($LogFiles), 0)
                Invoke-Item -Path $LogFiles[$LogFile]
            }
            else {
                return $LogFiles
            }
        }
    }
    else {
        Write-Error 'TeamViewer is not installed.'
    }
}



function Get-TeamViewerManagedDevice {
    [CmdletBinding(DefaultParameterSetName = "List")]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(ParameterSetName = "ByDeviceId")]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedDeviceId } )]
        [Alias("DeviceId")]
        [Alias("Device")]
        [guid]
        $Id,

        [Parameter(Mandatory = $true, ParameterSetName = "ListGroup")]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedGroupId } )]
        [Alias("GroupId")]
        [object]
        $Group,

        [Parameter(ParameterSetName = "ListGroup")]
        [switch]
        $Pending
    )

    # default is 'List':
    $resourceUri = "$(Get-TeamViewerApiUri)/managed/devices";
    $parameters = @{ }
    $isListOperation = $true

    switch ($PsCmdlet.ParameterSetName) {
        'ByDeviceId' {
            $resourceUri += "/$Id"
            $parameters = $null
            $isListOperation = $false
        }
        'ListGroup' {
            $groupId = $Group | Resolve-TeamViewerManagedGroupId
            $resourceUri = "$(Get-TeamViewerApiUri)/managed/groups/$groupId/$(if ($Pending) { "pending-" })devices"
        }
    }

    do {
        $response = Invoke-TeamViewerRestMethod `
            -ApiToken $ApiToken `
            -Uri $resourceUri `
            -Method Get `
            -Body $parameters `
            -WriteErrorTo $PSCmdlet `
            -ErrorAction Stop

        if ($PsCmdlet.ParameterSetName -Eq 'ByDeviceId') {
            Write-Output ($response | ConvertTo-TeamViewerManagedDevice)
        }
        else {
            $parameters.paginationToken = $response.nextPaginationToken
            Write-Output ($response.resources | ConvertTo-TeamViewerManagedDevice)
        }
    } while ($isListOperation -And $parameters.paginationToken)
}



function Get-TeamViewerManagedGroup {
    [CmdletBinding(DefaultParameterSetName = "List")]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(ParameterSetName = "ByGroupId")]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedGroupId } ) ]
        [Alias("GroupId")]
        [guid]
        $Id,

        [Parameter(ParameterSetName = "ByDeviceId")]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedDeviceId } )]
        [Alias("DeviceId")]
        [object]
        $Device
    )

    $resourceUri = "$(Get-TeamViewerApiUri)/managed/groups"
    $parameters = @{ }

    switch ($PsCmdlet.ParameterSetName) {
        'ByGroupId' {
            $resourceUri += "/$Id"
            $parameters = $null
        }
        'ByDeviceId' {
            $deviceId = $Device | Resolve-TeamViewerManagedDeviceId
            $resourceUri = "$(Get-TeamViewerApiUri)/managed/devices/$deviceId/groups"
        }
    }

    do {
        $response = Invoke-TeamViewerRestMethod `
            -ApiToken $ApiToken `
            -Uri $resourceUri `
            -Method Get `
            -Body $parameters `
            -WriteErrorTo $PSCmdlet `
            -ErrorAction Stop

        if ($PsCmdlet.ParameterSetName -Eq 'ByGroupId') {
            Write-Output ($response | ConvertTo-TeamViewerManagedGroup)
        }
        else {
            $parameters.paginationToken = $response.nextPaginationToken
            Write-Output ($response.resources | ConvertTo-TeamViewerManagedGroup)
        }
    } while ($PsCmdlet.ParameterSetName -In @('List', 'ByDeviceId') `
            -And $parameters.paginationToken)
}



function Get-TeamViewerManagementId {
    if (Test-TeamViewerInstallation) {
        switch (Get-OperatingSystem) {
            'Windows' {
                $regKeyPath = Join-Path (Get-TeamViewerRegKeyPath) 'DeviceManagementV2'
                $regKey = if (Test-Path -LiteralPath $regKeyPath) { Get-Item -Path $regKeyPath }
                if ($regKey) {
                    $unmanaged = [bool]($regKey.GetValue('Unmanaged'))
                    $managementId = $regKey.GetValue('ManagementId')
                }
            }
            'Linux' {
                $unmanaged = [bool](Get-TeamViewerLinuxGlobalConfig -Name 'DeviceManagementV2\Unmanaged')
                $managementId = Get-TeamViewerLinuxGlobalConfig -Name 'DeviceManagementV2\ManagementId'
            }
        }
        if (!$unmanaged -And $managementId) {
            Write-Output ([guid]$managementId)
        }
    }
}



function Get-TeamViewerManager {
    [CmdletBinding(DefaultParameterSetName = "ByDeviceId")]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true, ParameterSetName = "ByDeviceId")]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedDeviceId } )]
        [Alias("DeviceId")]
        [object]
        $Device,

        [Parameter(Mandatory = $true, ParameterSetName = "ByGroupId")]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedGroupId } )]
        [Alias("GroupId")]
        [object]
        $Group
    )

    $resourceUri = $null
    switch ($PsCmdlet.ParameterSetName) {
        'ByDeviceId' {
            $deviceId = $Device | Resolve-TeamViewerManagedDeviceId
            $resourceUri = "$(Get-TeamViewerApiUri)/managed/devices/$deviceId/managers"
        }
        'ByGroupId' {
            $groupId = $Group | Resolve-TeamViewerManagedGroupId
            $resourceUri = "$(Get-TeamViewerApiUri)/managed/groups/$groupId/managers"
        }
    }

    $response = Invoke-TeamViewerRestMethod `
        -ApiToken $ApiToken `
        -Uri $resourceUri `
        -Method Get `
        -WriteErrorTo $PSCmdlet `
        -ErrorAction Stop

    switch ($PsCmdlet.ParameterSetName) {
        'ByDeviceId' {
            Write-Output ($response.resources | ConvertTo-TeamViewerManager -DeviceId $deviceId)
        }
        'ByGroupId' {
            Write-Output ($response.resources | ConvertTo-TeamViewerManager -GroupId $groupId)
        }
    }
}



function Get-TeamViewerPolicy {
    [CmdletBinding(DefaultParameterSetName = "FilteredList")]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(ParameterSetName = "ByPolicyId")]
        [Alias("PolicyId")]
        [guid]
        $Id
    )

    $resourceUri = "$(Get-TeamViewerApiUri)/teamviewerpolicies";
    $parameters = @{ }

    switch ($PsCmdlet.ParameterSetName) {
        'ByPolicyId' {
            $resourceUri += "/$Id"
            $parameters = $null
        }
    }

    $response = Invoke-TeamViewerRestMethod `
        -ApiToken $ApiToken `
        -Uri $resourceUri `
        -Method Get `
        -Body $parameters `
        -WriteErrorTo $PSCmdlet `
        -ErrorAction Stop

    Write-Output ($response.policies | ConvertTo-TeamViewerPolicy)
}




function Get-TeamViewerRoleAssignmentToAccount {
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerUserRoleId } )]
        [Alias('UserRole')]
        [string]
        $UserRoleId
    )


    $resourceUri = "$(Get-TeamViewerApiUri)/userroles/assignments/account?userRoleId=$UserRoleId"
    $parameters = $null
    do {
        $response = Invoke-TeamViewerRestMethod `
            -ApiToken $ApiToken `
            -Uri $resourceUri `
            -Method Get `
            -Body $parameters `
            -WriteErrorTo $PSCmdlet `
            -ErrorAction Stop
        if ($response.ContinuationToken) {
            $resourceUri += '&continuationToken=' + $response.ContinuationToken
        }
        Write-Output ($response.AssignedToUsers | ConvertTo-TeamViewerRoleAssignedUser )
    }while ($response.ContinuationToken)
}



function Get-TeamViewerRoleAssignmentToUserGroup {
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript({ $_ | Resolve-TeamviewerUserRoleId })]
        [Alias('UserRole')]
        [string]
        $UserRoleId
    )

    Begin {
        $resourceUri = "$(Get-TeamViewerApiUri)/userroles/assignments/usergroups?userRoleId=$UserRoleId"
        $parameters = $null
    }
    Process {
        do {
            $response = Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $resourceUri `
                -Method Get `
                -Body $parameters `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop
            if ($response.ContinuationToken) {
                $resourceUri += "&continuationToken=" + $response.ContinuationToken
            }
            Write-Output ($response.AssignedToGroups | ConvertTo-TeamViewerRoleAssignedUserGroup )
        }while ($response.ContinuationToken)
    }
}



function Get-TeamViewerService {
    switch (Get-OperatingSystem) {
        'Windows' {
            Get-Service -Name (Get-TeamViewerServiceName)
        }
        'Linux' {
            Invoke-ExternalCommand /opt/teamviewer/tv_bin/script/teamviewer daemon status
        }
    }
}



function Get-TeamViewerSsoDomain {
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken
    )

    $resourceUri = "$(Get-TeamViewerApiUri)/ssoDomain";
    $response = Invoke-TeamViewerRestMethod `
        -ApiToken $ApiToken `
        -Uri $resourceUri `
        -Method Get `
        -WriteErrorTo $PSCmdlet `
        -ErrorAction Stop
    Write-Output ($response.domains | ConvertTo-TeamViewerSsoDomain)
}



function Get-TeamViewerSsoExclusion {
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerSsoDomainId } )]
        [Alias("Domain")]
        [object]
        $DomainId
    )

    $id = $DomainId | Resolve-TeamViewerSsoDomainId
    $resourceUri = "$(Get-TeamViewerApiUri)/ssoDomain/$id/exclusion";
    $parameters = @{ }
    do {
        $response = Invoke-TeamViewerRestMethod `
            -ApiToken $ApiToken `
            -Uri $resourceUri `
            -Method Get `
            -Body $parameters `
            -WriteErrorTo $PSCmdlet `
            -ErrorAction Stop

        Write-Output $response.emails
        $parameters.ct = $response.continuation_token
    } while ($parameters.ct)
}



function Get-TeamViewerUser {
    [CmdletBinding(DefaultParameterSetName = "FilteredList")]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(ParameterSetName = "ByUserId")]
        [ValidateScript( { $_ | Resolve-TeamViewerUserId } )]
        [Alias("UserId")]
        [string]
        $Id,

        [Parameter(ParameterSetName = "FilteredList")]
        [Alias("PartialName")]
        [string]
        $Name,

        [Parameter(ParameterSetName = "FilteredList")]
        [string[]]
        $Email,

        [Parameter(ParameterSetName = "FilteredList")]
        [string[]]
        $Permissions,

        [Parameter()]
        [ValidateSet("All", "Minimal")]
        $PropertiesToLoad = "All"
    )

    $parameters = @{ }
    switch ($PropertiesToLoad) {
        "All" { $parameters.full_list = $true }
        "Minimal" { }
    }

    $resourceUri = "$(Get-TeamViewerApiUri)/users"

    switch ($PsCmdlet.ParameterSetName) {
        "ByUserId" {
            $resourceUri += "/$Id"
            $parameters = $null
        }
        "FilteredList" {
            if ($Name) {
                $parameters['name'] = $Name
            }
            if ($Email) {
                $parameters['email'] = ($Email -join ',')
            }
            if ($Permissions) {
                $parameters['permissions'] = ($Permissions -join ',')
            }
        }
    }

    $response = Invoke-TeamViewerRestMethod `
        -ApiToken $ApiToken `
        -Uri $resourceUri `
        -Method Get `
        -Body $parameters `
        -WriteErrorTo $PSCmdlet `
        -ErrorAction Stop

    if ($PsCmdlet.ParameterSetName -Eq "ByUserId") {
        Write-Output ($response | ConvertTo-TeamViewerUser -PropertiesToLoad $PropertiesToLoad)
    }
    else {
        Write-Output ($response.users | ConvertTo-TeamViewerUser -PropertiesToLoad $PropertiesToLoad)
    }
}



function Get-TeamViewerUserGroup {
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter()]
        [ValidateScript( { $_ | Resolve-TeamViewerUserGroupId } )]
        [Alias("UserGroupId")]
        [Alias("Id")]
        [object]
        $UserGroup
    )

    Begin {
        $resourceUri = "$(Get-TeamViewerApiUri)/usergroups"
        $parameters = @{ }
        $isListOperation = $true

        if ($UserGroup) {
            $GroupId = $UserGroup | Resolve-TeamViewerUserGroupId
            $resourceUri += "/$GroupId"
            $parameters = $null
            $isListOperation = $false
        }
    }

    Process {
        do {
            $response = Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $resourceUri `
                -Method Get `
                -Body $parameters `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop
            if ($UserGroup) {
                Write-Output ($response | ConvertTo-TeamViewerUserGroup)
            }
            else {
                $parameters.paginationToken = $response.nextPaginationToken
                Write-Output ($response.resources | ConvertTo-TeamViewerUserGroup)
            }
        } while ($isListOperation -And $parameters.paginationToken)
    }
}



function Get-TeamViewerUserGroupMember {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerUserGroupId } )]
        [Alias("UserGroupId")]
        [Alias("Id")]
        [object]
        $UserGroup
    )

    Begin {
        $id = $UserGroup | Resolve-TeamViewerUserGroupId
        $resourceUri = "$(Get-TeamViewerApiUri)/usergroups/$id/members"
        $parameters = @{ }
    }

    Process {
        do {
            $response = Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $resourceUri `
                -Method Get `
                -Body $parameters `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop
            $parameters.paginationToken = $response.nextPaginationToken
            Write-Output ($response.resources | ConvertTo-TeamViewerUserGroupMember)
        } while ($parameters.paginationToken)
    }
}



function Get-TeamViewerUserRole {
    [CmdletBinding(DefaultParameterSetName = '')]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken
    )

    Begin{
    $parameters = @{ }
    $resourceUri = "$(Get-TeamViewerApiUri)/userroles"
    }

Process{
    $response = Invoke-TeamViewerRestMethod `
        -ApiToken $ApiToken `
        -Uri $resourceUri `
        -Method Get `
        -Body $parameters `
        -WriteErrorTo $PSCmdlet `
        -ErrorAction Stop
    Write-Output ($response.Roles | ConvertTo-TeamViewerUserRole )
}
}



function Get-TeamViewerVersion {
    if (Test-TeamViewerInstallation) {
        switch (Get-OperatingSystem) {
            'Windows' {
                return (Get-ItemPropertyValue -Path (Get-TeamViewerRegKeyPath) -Name 'Version')
            }
            'Linux' {
                return (Get-TeamViewerLinuxGlobalConfig -Name 'Version')
            }
        }
    }
}



function Invoke-TeamViewerPackageDownload {
    Param(
        [Parameter()]
        [ValidateSet('Full', 'Host', 'MSI32', 'MSI64', 'Portable', 'QuickJoin', 'QuickSupport', 'Full64Bit')]
        [ValidateScript( {
                if (($_ -ne 'Full') -And ((Get-OperatingSystem) -ne 'Windows')) {
                    $PSCmdlet.ThrowTerminatingError(
                        ("PackageType parameter is only supported on Windows platforms" | `
                                ConvertTo-ErrorRecord -ErrorCategory InvalidArgument))
                }
                $true
            })]
        [string]
        $PackageType,

        [Parameter()]
        [ValidateScript( {
                if ((Get-OperatingSystem) -ne 'Windows') {
                    $PSCmdlet.ThrowTerminatingError(
                        ("MajorVersion parameter is only supported on Windows platforms" | `
                                ConvertTo-ErrorRecord -ErrorCategory InvalidArgument))
                }
                if($PackageType -eq 'MSI32' -or 'MSI64' ){
                    $PSCmdlet.ThrowTerminatingError(
                        ("MajorVersion parameter is not supported for MSI packages" | `
                                ConvertTo-ErrorRecord -ErrorCategory InvalidArgument))
                }
                if ($_ -lt 14) {
                    $PSCmdlet.ThrowTerminatingError(
                        ("Unsupported TeamViewer version $_" | `
                                ConvertTo-ErrorRecord -ErrorCategory InvalidArgument))
                }
                $true
            } )]
        [int]
        $MajorVersion,

        [Parameter()]
        [string]
        $TargetDirectory = (Get-Location).Path,

        [Parameter()]
        [switch]
        $Force
    )

    if ((-not $PackageType) -And ((Get-OperatingSystem) -eq 'Windows')) {
        $Package = $host.ui.PromptForChoice('Select Package Type', 'Choose a package type:', `
            @('Full', 'Host', 'MSI32', 'MSI64', 'Portable', 'QuickJoin', 'QuickSupport', 'Full64Bit'), 0)
        $PackageType = @('Full', 'Host', 'MSI32', 'MSI64', 'Portable', 'QuickJoin', 'QuickSupport', 'Full64Bit')[$Package]
    }

    $additionalPath = ''
    switch (Get-OperatingSystem) {
        'Windows' {
            $filename = switch ($PackageType) {
                'Full' { 'TeamViewer_Setup.exe' }
                'MSI32' { 'TeamViewer_MSI32.zip' }
                'MSI64' { 'TeamViewer_MSI64.zip' }
                'Host' { 'TeamViewer_Host_Setup.exe' }
                'Portable' { 'TeamViewerPortable.zip' }
                'QuickJoin' { 'TeamViewerQJ.exe' }
                'QuickSupport' { 'TeamViewerQS.exe' }
                'Full64Bit' { 'TeamViewer_Setup_x64.exe' }
            }
            if ($MajorVersion) {
                $additionalPath = "/version_$($MajorVersion)x"
            }
            if(($PackageType -eq 'MSI32' -or 'MSI64' )){
                $additionalPath = '/version_15x'
            }
        }
        'Linux' {
            $releaseInfo = (Get-Content /etc/*-release)
            $filename = switch -Regex ($releaseInfo) {
                'debian|ubuntu' {
                    $platform = if ([Environment]::Is64BitOperatingSystem) { 'amd64' } else { 'i386' }
                    "teamviewer_$platform.deb"
                }
                'centos|rhel|fedora' {
                    $platform = if ([Environment]::Is64BitOperatingSystem) { 'x86_64' } else { 'i686' }
                    "teamviewer.$platform.rpm"
                }
                'suse|opensuse' {
                    $platform = if ([Environment]::Is64BitOperatingSystem) { 'x86_64' } else { 'i686' }
                    "teamviewer-suse.$platform.rpm"
                }
            }
            $filename = $filename | Select-Object -First 1
            $additionalPath = '/linux'
        }
    }

    $downloadUrl = "https://dl.teamviewer.com/download$additionalPath/$filename"
    $targetFile = Join-Path $TargetDirectory $filename

    if ((Test-Path $targetFile) -And -Not $Force -And `
            -Not $PSCmdlet.ShouldContinue("File $targetFile already exists. Override?", "Override existing file?")) {
        return
    }

    Write-Verbose "Downloading $downloadUrl to $targetFile"
    $client = New-Object System.Net.WebClient
    $client.DownloadFile($downloadUrl, $targetFile)
    Write-Output $targetFile
}



function Invoke-TeamViewerPing {
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken
    )

    $resourceUri = "$(Get-TeamViewerApiUri)/ping"
    $result = Invoke-TeamViewerRestMethod `
        -ApiToken $ApiToken `
        -Uri $resourceUri `
        -Method Get `
        -WriteErrorTo $PSCmdlet `
        -ErrorAction Stop
    Write-Output $result.token_valid
}



function New-TeamViewerContact {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [Alias('EmailAddress')]
        [string]
        $Email,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerGroupId } )]
        [Alias("GroupId")]
        [object]
        $Group,

        [Parameter()]
        [switch]
        $Invite
    )

    $body = @{
        email   = $Email
        groupid = $Group | Resolve-TeamViewerGroupId
    }
    if ($Invite) {
        $body['invite'] = $true
    }

    $resourceUri = "$(Get-TeamViewerApiUri)/contacts"
    if ($PSCmdlet.ShouldProcess($Email, "Create contact")) {
        $response = Invoke-TeamViewerRestMethod `
            -ApiToken $ApiToken `
            -Uri $resourceUri `
            -Method Post `
            -ContentType "application/json; charset=utf-8" `
            -Body ([System.Text.Encoding]::UTF8.GetBytes(($body | ConvertTo-Json))) `
            -WriteErrorTo $PSCmdlet `
            -ErrorAction Stop

        $result = ($response | ConvertTo-TeamViewerContact)
        Write-Output $result
    }
}



function New-TeamViewerDevice {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [int]
        $TeamViewerId,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerGroupId } )]
        [Alias("GroupId")]
        [object]
        $Group,

        [Parameter()]
        [Alias("Alias")]
        [string]
        $Name,

        [Parameter()]
        [string]
        $Description,

        [Parameter()]
        [securestring]
        $Password
    )

    $body = @{
        remotecontrol_id = "r$TeamViewerId"
        groupid          = $Group | Resolve-TeamViewerGroupId
    }

    if ($Name) {
        $body['alias'] = $Name
    }
    if ($Description) {
        $body['description'] = $Description
    }
    if ($Password) {
        $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password)
        $body['password'] = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)
        [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr) | Out-Null
    }

    $resourceUri = "$(Get-TeamViewerApiUri)/devices"
    if ($PSCmdlet.ShouldProcess($TeamViewerId, "Create device entry")) {
        $response = Invoke-TeamViewerRestMethod `
            -ApiToken $ApiToken `
            -Uri $resourceUri `
            -Method Post `
            -ContentType "application/json; charset=utf-8" `
            -Body ([System.Text.Encoding]::UTF8.GetBytes(($body | ConvertTo-Json))) `
            -WriteErrorTo $PSCmdlet `
            -ErrorAction Stop

        $result = ($response | ConvertTo-TeamViewerDevice)
        Write-Output $result
    }
}



function New-TeamViewerGroup {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [string]
        $Name,

        [Parameter()]
        [ValidateScript( { $_ | Resolve-TeamViewerPolicyId } )]
        [Alias("PolicyId")]
        [object]
        $Policy
    )

    $body = @{ name = $Name }
    if ($Policy) {
        $body["policy_id"] = $Policy | Resolve-TeamViewerPolicyId
    }

    $resourceUri = "$(Get-TeamViewerApiUri)/groups"
    if ($PSCmdlet.ShouldProcess($Name, "Create group")) {
        $response = Invoke-TeamViewerRestMethod `
            -ApiToken $ApiToken `
            -Uri $resourceUri `
            -Method Post `
            -ContentType "application/json; charset=utf-8" `
            -Body ([System.Text.Encoding]::UTF8.GetBytes(($body | ConvertTo-Json))) `
            -WriteErrorTo $PSCmdlet `
            -ErrorAction Stop
        Write-Output ($response | ConvertTo-TeamViewerGroup)
    }
}



function New-TeamViewerManagedGroup {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [string]
        $Name
    )

    $body = @{ name = $Name }
    $resourceUri = "$(Get-TeamViewerApiUri)/managed/groups"
    if ($PSCmdlet.ShouldProcess($Name, "Create managed group")) {
        $response = Invoke-TeamViewerRestMethod `
            -ApiToken $ApiToken `
            -Uri $resourceUri `
            -Method Post `
            -ContentType "application/json; charset=utf-8" `
            -Body ([System.Text.Encoding]::UTF8.GetBytes(($body | ConvertTo-Json))) `
            -WriteErrorTo $PSCmdlet `
            -ErrorAction Stop
        Write-Output ($response | ConvertTo-TeamViewerManagedGroup)
    }
}



function New-TeamViewerPolicy {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [string]
        $Name,

        [Parameter()]
        [AllowEmptyCollection()]
        [object[]]
        $Settings,

        [Parameter()]
        [switch]
        $DefaultPolicy = $False
    )

    $body = @{
        name     = $Name
        default  = [boolean]$DefaultPolicy
        settings = @()
    }

    if ($Settings) {
        $body.settings = @($Settings)
    }

    $resourceUri = "$(Get-TeamViewerApiUri)/teamviewerpolicies"
    if ($PSCmdlet.ShouldProcess($Name, "Create policy")) {
        Invoke-TeamViewerRestMethod `
            -ApiToken $ApiToken `
            -Uri $resourceUri `
            -Method Post `
            -ContentType "application/json; charset=utf-8" `
            -Body ([System.Text.Encoding]::UTF8.GetBytes(($body | ConvertTo-Json))) `
            -WriteErrorTo $PSCmdlet | `
            Out-Null
    }
}



function New-TeamViewerUser {
    [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = "WithPassword")]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [Alias('EmailAddress')]
        [string]
        $Email,

        [Parameter(Mandatory = $true)]
        [Alias('DisplayName')]
        [string]
        $Name,

        [Parameter(Mandatory = $true, ParameterSetName = "WithPassword")]
        [securestring]
        $Password,

        [Parameter(ParameterSetName = "WithoutPassword")]
        [Alias('NoPassword')]
        [switch]
        $WithoutPassword,

        [Parameter()]
        [securestring]
        $SsoCustomerIdentifier,

        [Parameter()]
        [array]
        $Permissions,

        [Parameter()]
        [ValidateScript( { $_ | Resolve-TeamViewerLanguage } )]
        [cultureinfo]
        $Culture
    )

    if (-Not $Culture) {
        try { $Culture = Get-Culture }
        catch { $Culture = 'en' }
    }

    $body = @{
        email       = $Email
        name        = $Name
        language    = $Culture | Resolve-TeamViewerLanguage
        permissions = $Permissions -join ','
    }

    if ($Password -And -Not $WithoutPassword) {
        $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password)
        $body['password'] = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)
        [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr) | Out-Null
    }

    if ($SsoCustomerIdentifier) {
        $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SsoCustomerIdentifier)
        $body['sso_customer_id'] = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)
        [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr) | Out-Null
    }

    $resourceUri = "$(Get-TeamViewerApiUri)/users"
    if ($PSCmdlet.ShouldProcess("$Name <$Email>", "Create user")) {
        $response = Invoke-TeamViewerRestMethod `
            -ApiToken $ApiToken `
            -Uri $resourceUri `
            -Method Post `
            -ContentType "application/json; charset=utf-8" `
            -Body ([System.Text.Encoding]::UTF8.GetBytes(($body | ConvertTo-Json))) `
            -WriteErrorTo $PSCmdlet `
            -ErrorAction Stop

        $result = ($response | ConvertTo-TeamViewerUser)
        $result.Email = $Email
        Write-Output $result
    }
}



function New-TeamViewerUserGroup {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [string]
        $Name
    )

    Begin {
        $resourceUri = "$(Get-TeamViewerApiUri)/usergroups"
        $body = @{ name = $Name }
    }

    Process {
        if ($PSCmdlet.ShouldProcess($Name, "Create user group")) {
            $response = Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $resourceUri `
                -Method Post `
                -ContentType "application/json; charset=utf-8" `
                -Body ([System.Text.Encoding]::UTF8.GetBytes(($body | ConvertTo-Json))) `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop
            Write-Output ($response | ConvertTo-TeamViewerUserGroup)
        }
    }
}




function New-TeamViewerUserRole {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true )]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [Alias('UserRoleName')]
        [string]
        $Name,

        [Parameter(Mandatory = $false)]
        [AllowEmptyCollection()]
        [object[]]
        $Permissions
    )
    Begin {
        $resourceUri = "$(Get-TeamViewerApiUri)/userroles"
        $body = @{
            Name        = $Name
            Permissions = @()
        }

        if ($Permissions) {
            $body.Permissions = @($Permissions)
        }
    }

    Process {
        if ($PSCmdlet.ShouldProcess($Name, 'Create User Role')) {
            $response = Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $resourceUri `
                -Method Post `
                -ContentType 'application/json; charset=utf-8' `
                -Body ([System.Text.Encoding]::UTF8.GetBytes(($body | ConvertTo-Json))) `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop

            $result = ($response.Role | ConvertTo-TeamViewerUserRole)
            Write-Output $result
        }
    }

}



function Publish-TeamViewerGroup {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerGroupId } )]
        [Alias("GroupId")]
        [object]
        $Group,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerUserId } )]
        [Alias("UserId")]
        [object[]]
        $User,

        [Parameter()]
        [ValidateSet("read", "readwrite")]
        $Permissions = "read"
    )

    # Warning suppresion doesn't seem to work.
    # See https://github.com/PowerShell/PSScriptAnalyzer/issues/1472
    $null = $Permissions

    $groupId = $Group | Resolve-TeamViewerGroupId
    $userIds = $User | Resolve-TeamViewerUserId
    $resourceUri = "$(Get-TeamViewerApiUri)/groups/$groupId/share_group"
    $body = @{
        users = @($userIds | ForEach-Object { @{
                    userid      = $_
                    permissions = $Permissions
                } })
    }

    if ($PSCmdlet.ShouldProcess($userids, "Add group share")) {
        Invoke-TeamViewerRestMethod `
            -ApiToken $ApiToken `
            -Uri $resourceUri `
            -Method Post `
            -ContentType "application/json; charset=utf-8" `
            -Body ([System.Text.Encoding]::UTF8.GetBytes(($body | ConvertTo-Json))) `
            -WriteErrorTo $PSCmdlet | `
            Out-Null
    }
}



function Remove-TeamViewerAssignment {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param()


    if (Test-TeamViewerInstallation) {
        $OS = Get-OperatingSystem
        $CurrentDirectory = Get-Location
        $installationDirectory = Get-TeamViewerInstallationDirectory
        Set-Location $installationDirectory
        if ($OS -eq 'Windows') {
            $cmd = 'unassign'
            $FilePath = 'TeamViewer.exe'
        }
        elseif ($OS -eq 'Linux') {
            $cmd = 'teamviewer unassign'
            $FilePath = 'sudo'
        }
        $process = Start-Process -FilePath $FilePath -ArgumentList $cmd -Wait -PassThru
        $process.ExitCode | Resolve-AssignmentErrorCode
        Set-Location $CurrentDirectory
    }
    else {
        Write-Output 'TeamViewer is not installed.'
    }
}





function Remove-TeamViewerContact {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerContactId } )]
        [Alias("ContactId")]
        [Alias("Id")]
        [object]
        $Contact
    )
    Process {
        $contactId = $Contact | Resolve-TeamViewerContactId
        $resourceUri = "$(Get-TeamViewerApiUri)/contacts/$contactId"
        if ($PSCmdlet.ShouldProcess($contactId, "Remove contact")) {
            Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $resourceUri `
                -Method Delete `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop | `
                Out-Null
        }
    }
}



function Remove-TeamViewerCustomization {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param()

    if (Get-OperatingSystem -eq 'Windows') {
        if (Test-TeamViewerInstallation) {
            $installationDirectory = Get-TeamViewerInstallationDirectory
            $currentDirectory = Get-Location
            Set-Location $installationDirectory
            $cmd = 'customize --remove'
            $process = Start-Process -FilePath TeamViewer.exe -ArgumentList $cmd -Wait -PassThru
            $process.ExitCode | Resolve-CustomizationErrorCode
            Set-Location $currentDirectory
        }
        else {
            Write-Error 'TeamViewer is not installed'
        }
    }
    else {
        Write-Error 'Customization is currently supported only on Windows.'
    }
}



function Remove-TeamViewerDevice {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerDeviceId } )]
        [Alias("DeviceId")]
        [Alias("Id")]
        [object]
        $Device
    )
    Process {
        $deviceId = $Device | Resolve-TeamViewerDeviceId
        $resourceUri = "$(Get-TeamViewerApiUri)/devices/$deviceId"
        if ($PSCmdlet.ShouldProcess($deviceId, "Remove device entry")) {
            Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $resourceUri `
                -Method Delete `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop | `
                Out-Null
        }
    }
}



function Remove-TeamViewerGroup {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerGroupId } )]
        [Alias("GroupId")]
        [Alias("Id")]
        [object]
        $Group
    )
    Process {
        $groupId = $Group | Resolve-TeamViewerGroupId
        $resourceUri = "$(Get-TeamViewerApiUri)/groups/$groupId"

        if ($PSCmdlet.ShouldProcess($groupId, "Remove group")) {
            Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $resourceUri `
                -Method Delete `
                -WriteErrorTo $PSCmdlet | `
                Out-Null
        }
    }
}



function Remove-TeamViewerManagedDevice {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedDeviceId } )]
        [Alias("DeviceId")]
        [object]
        $Device,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedGroupId } )]
        [Alias("GroupId")]
        [object]
        $Group
    )
    Process {
        $deviceId = $Device | Resolve-TeamViewerManagedDeviceId
        $groupId = $Group | Resolve-TeamViewerManagedGroupId

        $resourceUri = "$(Get-TeamViewerApiUri)/managed/groups/$groupId/devices/$deviceId"

        if ($PSCmdlet.ShouldProcess($deviceId, "Remove device from managed group")) {
            Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $resourceUri `
                -Method Delete `
                -WriteErrorTo $PSCmdlet | `
                Out-Null
        }
    }
}



function Remove-TeamViewerManagedDeviceManagement {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedDeviceId } )]
        [Alias('DeviceId')]
        [object]
        $Device
    )
    Process {
        $deviceId = $Device | Resolve-TeamViewerManagedDeviceId

        $resourceUri = "$(Get-TeamViewerApiUri)/managed/devices/$deviceId"

        if ($PSCmdlet.ShouldProcess($deviceId, 'Remove Management from a device (clears all managers and groups)')) {
            Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $resourceUri `
                -Method Delete `
                -WriteErrorTo $PSCmdlet | `
                Out-Null
        }
    }
}



function Remove-TeamViewerManagedGroup {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedGroupId } )]
        [Alias("GroupId")]
        [Alias("Id")]
        [object]
        $Group
    )
    Process {
        $groupId = $Group | Resolve-TeamViewerManagedGroupId
        $resourceUri = "$(Get-TeamViewerApiUri)/managed/groups/$groupId"

        if ($PSCmdlet.ShouldProcess($groupId, "Remove managed group")) {
            Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $resourceUri `
                -Method Delete `
                -WriteErrorTo $PSCmdlet | `
                Out-Null
        }
    }
}



function Remove-TeamViewerManager {
    [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = "ByDeviceId")]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript( {
                if (($_.PSObject.TypeNames -contains 'TeamViewerPS.Manager') -And -Not $_.GroupId -And -Not $_.DeviceId) {
                    $PSCmdlet.ThrowTerminatingError(
                        ("Invalid manager object. Manager must be a group or device manager." | `
                                ConvertTo-ErrorRecord -ErrorCategory InvalidArgument))
                }
                $_ | Resolve-TeamViewerManagerId
            })]
        [Alias("ManagerId")]
        [Alias("Id")]
        [object]
        $Manager,

        [Parameter(ParameterSetName = 'ByDeviceId')]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedDeviceId } )]
        [Alias("DeviceId")]
        [object]
        $Device,

        [Parameter(ParameterSetName = 'ByGroupId')]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedGroupId })]
        [Alias("GroupId")]
        [object]
        $Group
    )
    Process {
        $deviceId = $null
        $groupId = $null
        if ($Manager.PSObject.TypeNames -contains 'TeamViewerPS.Manager') {
            if ($Device -Or $Group) {
                $PSCmdlet.ThrowTerminatingError(
                    ("Device or Group parameter must not be specified if a [TeamViewerPS.Manager] object is given." | `
                            ConvertTo-ErrorRecord -ErrorCategory InvalidArgument))
            }
            if ($Manager.DeviceId) {
                $deviceId = $Manager.DeviceId
            }
            elseif ($Manager.GroupId) {
                $groupId = $Manager.GroupId
            }
        }
        elseif ($Device) {
            $deviceId = $Device | Resolve-TeamViewerManagedDeviceId
        }
        elseif ($Group) {
            $groupId = $Group | Resolve-TeamViewerManagedGroupId
        }
        else {
            $PSCmdlet.ThrowTerminatingError(
                ("Device or Group parameter must be specified if no [TeamViewerPS.Manager] object is given." | `
                        ConvertTo-ErrorRecord -ErrorCategory InvalidArgument))
        }

        $managerId = $Manager | Resolve-TeamViewerManagerId
        if ($deviceId) {
            $resourceUri = "$(Get-TeamViewerApiUri)/managed/devices/$deviceId/managers/$managerId"
            $processMessage = "Remove manager from managed device"
        }
        elseif ($groupId) {
            $resourceUri = "$(Get-TeamViewerApiUri)/managed/groups/$groupId/managers/$managerId"
            $processMessage = "Remove manager from managed group"
        }

        if ($PSCmdlet.ShouldProcess($managerId, $processMessage)) {
            Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $resourceUri `
                -Method Delete `
                -WriteErrorTo $PSCmdlet | `
                Out-Null
        }
    }
}



function Remove-TeamViewerPolicy {
    [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'ByParameters')]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerPolicyId } )]
        [Alias('PolicyId')]
        [object]
        $Policy
    )
    Process {
        $policyId = $Policy | Resolve-TeamViewerPolicyId
        $resourceUri = "$(Get-TeamViewerApiUri)/teamviewerpolicies/$policyId"

        if ($PSCmdlet.ShouldProcess($policyId, "Delete policy")) {
            Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $resourceUri `
                -Method Delete `
                -WriteErrorTo $PSCmdlet | `
                Out-Null
        }
    }
}



function Remove-TeamviewerPolicyFromManagedDevice {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedDeviceId } )]
        [Alias("DeviceId")]
        [object]
        $Device,

        [Parameter(Mandatory = $true)]
        [PolicyType]
        $PolicyType
    )
    Begin {
        $body = @{
            'policy_type' = [int]$PolicyType
        }
    }
    Process {
        $deviceId = $Device | Resolve-TeamViewerManagedDeviceId
        $resourceUri = "$(Get-TeamViewerApiUri)/managed/devices/$deviceId/policy/remove"

        if ($PSCmdlet.ShouldProcess($Device.ToString(), "Change managed device entry")) {
            Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $resourceUri `
                -Method Put `
                -ContentType "application/json; charset=utf-8" `
                -Body ([System.Text.Encoding]::UTF8.GetBytes(($body | ConvertTo-Json))) `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop | `
                Out-Null
        }
    }
}



function Remove-TeamViewerPSProxy {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param()

    $global:TeamViewerProxyUriRemoved = $true
    $global:TeamViewerProxyUriRemoved | Out-Null  # https://github.com/PowerShell/PSScriptAnalyzer/issues/1472
    if($PSCmdlet.ShouldProcess($TeamViewerProxyUriRemoved,"Remove proxy for WebAPI")){
    $global:TeamViewerProxyUriSet = $null
    $global:TeamViewerProxyUriSet | Out-Null  # https://github.com/PowerShell/PSScriptAnalyzer/issues/1472
    [Environment]::SetEnvironmentVariable('TeamViewerProxyUri','', 'User')
    }
}



function Remove-TeamViewerRoleFromAccount {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerUserRoleId } )]
        [Alias('UserRole')]
        [object]
        $UserRoleId,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('Id', 'UserIds')]
        [string[]]
        $Accounts
    )

    Begin {
        $id = $UserRoleId | Resolve-TeamViewerUserRoleId
        $null = $ApiToken
        $resourceUri = "$(Get-TeamViewerApiUri)/userroles/unassign/account"
        $AccountsToRemove = @()
        $body = @{
            UserIds    = @()
            UserRoleId = $id
        }
        function Invoke-TeamViewerRestMethodInternal {
            $result = Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $resourceUri `
                -Method Post `
                -ContentType 'application/json; charset=utf-8' `
                -Body ([System.Text.Encoding]::UTF8.GetBytes(($body | ConvertTo-Json))) `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop
            Write-Output ($result)
        }

    }

    Process {
        if ($PSCmdlet.ShouldProcess($Accounts, 'Unassign Account from Role')) {
            if (($Accounts -notmatch 'u[0-9]+') -and ($Accounts -match '[0-9]+')) {
                $Accounts = $Accounts | ForEach-Object { $_.Insert(0, 'u') }
            }
            foreach ($Account in $Accounts) {
                $AccountsToRemove += $Account
                $body.UserIds = @($AccountsToRemove)
            }
        }
        if ($AccountsToRemove.Length -eq 100) {
            Invoke-TeamViewerRestMethodInternal
            $AccountsToRemove = @()
        }
    }
    End {
        if ($AccountsToRemove.Length -gt 0) {
            Invoke-TeamViewerRestMethodInternal
        }
    }
}



function Remove-TeamViewerRoleFromUserGroup {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerUserGroupId } )]
        [Alias('UserGroupId')]
        [Alias('Id')]
        [object]
        $UserGroup
    )

    Begin {
        $null = $ApiToken
        $resourceUri = "$(Get-TeamViewerApiUri)/userroles/unassign/usergroup"
        $body = @{
            UserGroupId = $UserGroup
        }
    }


    Process {
        if ($PSCmdlet.ShouldProcess($UserGroupId, 'Unassign Role from User Group')) {
            $result = Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $resourceUri `
                -Method Post `
                -ContentType 'application/json; charset=utf-8' `
                -Body ([System.Text.Encoding]::UTF8.GetBytes(($body | ConvertTo-Json))) `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop
            Write-Output ($result)
        }
    }
}



function Remove-TeamViewerSsoExclusion {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerSsoDomainId } )]
        [Alias("Domain")]
        [object]
        $DomainId,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string[]]
        $Email
    )
    Begin {
        $id = $DomainId | Resolve-TeamViewerSsoDomainId
        $resourceUri = "$(Get-TeamViewerApiUri)/ssoDomain/$id/exclusion"
        $emailsToRemove = @()
        $null = $ApiToken   # https://github.com/PowerShell/PSScriptAnalyzer/issues/1472

        function Invoke-RequestInternal {
            $body = @{
                emails = @($emailsToRemove)
            }
            Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $resourceUri `
                -Method Delete `
                -ContentType "application/json; charset=utf-8" `
                -Body ([System.Text.Encoding]::UTF8.GetBytes(($body | ConvertTo-Json))) `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop | `
                Out-Null
        }
    }
    Process {
        if ($PSCmdlet.ShouldProcess($Email, "Remove SSO exclusion")) {
            $emailsToRemove += $Email
        }
        if ($emailsToRemove.Length -eq 100) {
            Invoke-RequestInternal
            $emailsToRemove = @()
        }
    }
    End {
        if ($emailsToRemove.Length -gt 0) {
            Invoke-RequestInternal
        }
    }
}



function Remove-TeamViewerUser {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerUserId } )]
        [Alias("UserId")]
        [Alias("Id")]
        [object]
        $User,

        [Parameter()]
        [switch]
        $Permanent
    )
    Process {
        $userId = $User | Resolve-TeamViewerUserId
        $resourceUri = "$(Get-TeamViewerApiUri)/users/$userId"

        if ($Permanent) {
            $resourceUri += '?isPermanentDelete=true'
        }

        if ($PSCmdlet.ShouldProcess($userId, "Remove user")) {
            Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $resourceUri `
                -Method Delete `
                -WriteErrorTo $PSCmdlet | `
                Out-Null
        }
    }
}



function Remove-TeamViewerUserGroup {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerUserGroupId } )]
        [Alias("UserGroupId")]
        [Alias("Id")]
        [object]
        $UserGroup
    )

    Begin {
        $id = $UserGroup | Resolve-TeamViewerUserGroupId
        $resourceUri = "$(Get-TeamViewerApiUri)/usergroups/$id"
    }

    Process {
        if ($PSCmdlet.ShouldProcess($UserGroup.ToString(), "Remove user group")) {
            Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $resourceUri `
                -Method Delete `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop | `
                Out-Null
        }
    }
}



function Remove-TeamViewerUserGroupMember {
    [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'ByUserGroupMemberId')]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerUserGroupId } )]
        [Alias('UserGroupId')]
        [Alias('Id')]
        [object]
        $UserGroup,


        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerUserGroupMemberMemberId } )]
        [Alias('UserGroupMemberId')]
        [Alias('MemberId')]
        [Alias('UserId')]
        [Alias('User')]
        [object[]]
        $UserGroupMember
    )

    Begin {
        $id = $UserGroup | Resolve-TeamViewerUserGroupId
        $resourceUri = "$(Get-TeamViewerApiUri)/usergroups/$id/members"
        $membersToRemove = @()
        $null = $ApiToken # https://github.com/PowerShell/PSScriptAnalyzer/issues/1472
        $null = $UserGroupMember
        function Invoke-TeamViewerRestMethodInternal {
            Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $resourceUri `
                -Method Delete `
                -ContentType 'application/json; charset=utf-8' `
                -Body ([System.Text.Encoding]::UTF8.GetBytes(($body))) `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop | `
                Out-Null
        }

        function Get-MemberId {
            switch ($UserGroupMember) {
                { $UserGroupMember[0].PSObject.TypeNames -contains 'TeamViewerPS.UserGroupMember' } {
                    $UserGroupMember = $UserGroupMember | Resolve-TeamViewerUserGroupMemberMemberId
                    return $UserGroupMember
                }
                Default {
                    if ($UserGroupMember -notmatch 'u[0-9]+') {
                        ForEach-Object {
                            $UserGroupMember = [int[]]$UserGroupMember
                        }
                    }
                    else {
                        ForEach-Object {
                            $UserGroupMember = [int[]]$UserGroupMember.trim('u')
                        }
                    }
                    return $UserGroupMember
                }
            }
        }
    }

    Process {
        # when members are provided as pipeline input, each member is provided as separate statement,
        # thus the members should  be combined to one array in order to send a single request
        if ($PSCmdlet.ShouldProcess((Get-MemberId), 'Remove user group member')) {
            if (Get-MemberId -isnot [array]) {
                $membersToRemove += @(Get-MemberId)
            }
            else {
                $membersToRemove += Get-MemberId
            }
            $payload = $membersToRemove -join ', '
            $body = "[$payload]"
        }

        # WebAPI accepts max 100 accounts. Thus we send a request, and reset the `membersToRemove`
        # in order to accept more members
        if ($membersToRemove.Length -eq 100) {
            Invoke-TeamViewerRestMethodInternal
            $membersToRemove = @()
        }
    }

    End {
        # A request needs to be send if there were less than 100 members
        if ($membersToRemove.Length -gt 0) {
            Invoke-TeamViewerRestMethodInternal
        }
    }
}



function Remove-TeamViewerUserRole {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerUserRoleId } )]
        [Alias('UserRole')]
        [Alias('Id')]
        [object]
        $UserRoleId
    )

    Begin {
        $resourceUri = "$(Get-TeamViewerApiUri)/userroles?userRoleId=$UserRoleId"
    }

    Process {
        if ($PSCmdlet.ShouldProcess($UserRoleId.ToString(), 'Remove User Role')) {
            Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $resourceUri `
                -Method Delete `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop | `
                Out-Null
        }
    }
}



function Restart-TeamViewerService {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param()

    if ($PSCmdlet.ShouldProcess('TeamViewer service')) {
        switch (Get-OperatingSystem) {
            'Windows' {
                Restart-Service -Name (Get-TeamViewerServiceName)
            }
            'Linux' {
                Invoke-ExternalCommand /opt/teamviewer/tv_bin/script/teamviewer daemon restart
            }
        }
    }
}



function Set-TeamViewerAccount {
    [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'ByParameters')]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(ParameterSetName = 'ByParameters')]
        [Alias('DisplayName')]
        [string]
        $Name,

        [Parameter(ParameterSetName = 'ByParameters')]
        [Alias('EmailAddress')]
        [string]
        $Email,

        [Parameter(ParameterSetName = 'ByParameters')]
        [securestring]
        $Password,

        [Parameter(ParameterSetName = 'ByParameters')]
        [securestring]
        $OldPassword,

        [Parameter(ParameterSetName = 'ByParameters')]
        [ValidateScript( { $_ | Resolve-TeamViewerLanguage } )]
        [object]
        $EmailLanguage,

        [Parameter(Mandatory = $true, ParameterSetName = 'ByProperties')]
        [hashtable]
        $Property
    )

    # Warning suppresion doesn't seem to work.
    # See https://github.com/PowerShell/PSScriptAnalyzer/issues/1472
    $null = $Property

    $body = @{}
    switch ($PSCmdlet.ParameterSetName) {
        'ByParameters' {
            if ($Name) {
                $body['name'] = $Name
            }
            if ($Email) {
                $body['email'] = $Email
            }
            if ($Password) {
                if (-Not $OldPassword) {
                    $PSCmdlet.ThrowTerminatingError(
                        ("Old password required when attempting to change account password." | `
                                ConvertTo-ErrorRecord -ErrorCategory InvalidArgument))
                }

                $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password)
                $body['password'] = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)
                [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr) | Out-Null

                $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($OldPassword)
                $body['oldpassword'] = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)
                [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr) | Out-Null
            }
            if ($EmailLanguage) {
                $body['email_language'] = $EmailLanguage | Resolve-TeamViewerLanguage
            }
        }
        'ByProperties' {
            @('name', 'email', 'password', 'oldpassword', 'email_language') | `
                Where-Object { $Property[$_] } | `
                ForEach-Object { $body[$_] = $Property[$_] }
        }
    }

    if ($body.Count -eq 0) {
        $PSCmdlet.ThrowTerminatingError(
            ("The given input does not change the account." | `
                    ConvertTo-ErrorRecord -ErrorCategory InvalidArgument))
    }

    $resourceUri = "$(Get-TeamViewerApiUri)/account"

    if ($PSCmdlet.ShouldProcess("TeamViewer account")) {
        Invoke-TeamViewerRestMethod `
            -ApiToken $ApiToken `
            -Uri $resourceUri `
            -Method Put `
            -ContentType "application/json; charset=utf-8" `
            -Body ([System.Text.Encoding]::UTF8.GetBytes(($body | ConvertTo-Json))) `
            -WriteErrorTo $PSCmdlet | `
            Out-Null
    }
}



function Set-TeamViewerAPIUri {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $false)]
        [string]$NewUri,
        [Parameter(Mandatory = $false)]
        [bool]$Default
    )

    $config = [TeamViewerConfiguration]::GetInstance()
    $PSDefaultParameterValues = @{'CmdletName:Default' = $true }

    if ($PSCmdlet.ShouldProcess('TeamViewer account')) {
        if ($NewUri) {
            $config.APIUri = $NewUri
            Write-Output "TeamViewer API URL set to: $($config.APIUri)"
        }
        elseif ($Default) {
            $config.APIUri = 'https://webapi.teamviewer.com/api/v1'
            Write-Output "TeamViewer API URL set to: $($config.APIUri)"
        }
    }

}



function Set-TeamViewerDevice {
    [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = "Default")]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerDeviceId } )]
        [Alias("DeviceId")]
        [Alias("Id")]
        [object]
        $Device,

        [Parameter(ParameterSetName = "ChangeGroup")]
        [ValidateScript( { $_ | Resolve-TeamViewerGroupId } )]
        [Alias("GroupId")]
        [object]
        $Group,

        [Parameter(ParameterSetName = "ChangePolicy")]
        [ValidateScript( { $_ | Resolve-TeamViewerPolicyId -AllowInherit -AllowNone } )]
        [Alias("PolicyId")]
        [object]
        $Policy,

        [Parameter()]
        [Alias("Alias")]
        [string]
        $Name,

        [Parameter()]
        [string]
        $Description,

        [Parameter()]
        [securestring]
        $Password
    )
    Begin {
        $body = @{}

        if ($Name) {
            $body['alias'] = $Name
        }
        if ($Description) {
            $body['description'] = $Description
        }
        if ($Password) {
            $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password)
            $body['password'] = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)
            [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr) | Out-Null
        }
        if ($Group) {
            $body['groupid'] = $Group | Resolve-TeamViewerGroupId
        }
        if ($Policy) {
            $body['policy_id'] = $Policy | Resolve-TeamViewerPolicyId -AllowNone -AllowInherit
        }

        if ($body.Count -eq 0) {
            $PSCmdlet.ThrowTerminatingError(
                ("The given input does not change the device." | `
                        ConvertTo-ErrorRecord -ErrorCategory InvalidArgument))
        }
    }
    Process {
        $deviceId = $Device | Resolve-TeamViewerDeviceId
        $resourceUri = "$(Get-TeamViewerApiUri)/devices/$deviceId"

        if ($PSCmdlet.ShouldProcess($Device.ToString(), "Change device entry")) {
            Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $resourceUri `
                -Method Put `
                -ContentType "application/json; charset=utf-8" `
                -Body ([System.Text.Encoding]::UTF8.GetBytes(($body | ConvertTo-Json))) `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop | `
                Out-Null
        }
    }
}



function Set-TeamViewerGroup {
    [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'ByParameters')]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerGroupId } )]
        [Alias("GroupId")]
        [Alias("Id")]
        [object]
        $Group,

        [Parameter(ParameterSetName = 'ByParameters')]
        [string]
        $Name,

        [Parameter(ParameterSetName = 'ByParameters')]
        [ValidateScript( { $_ | Resolve-TeamViewerPolicyId } )]
        [Alias("PolicyId")]
        [object]
        $Policy,

        [Parameter(Mandatory = $true, ParameterSetName = 'ByProperties')]
        [hashtable]
        $Property
    )
    Begin {
        # Warning suppresion doesn't seem to work.
        # See https://github.com/PowerShell/PSScriptAnalyzer/issues/1472
        $null = $Property

        $body = @{}
        switch ($PSCmdlet.ParameterSetName) {
            'ByParameters' {
                $body['name'] = $Name
                if ($Policy) {
                    $body['policy_id'] = $Policy | Resolve-TeamViewerPolicyId
                }
            }
            'ByProperties' {
                @('name', 'policy_id') | `
                    Where-Object { $Property[$_] } | `
                    ForEach-Object { $body[$_] = $Property[$_] }
            }
        }

        if ($body.Count -eq 0) {
            $PSCmdlet.ThrowTerminatingError(
                ("The given input does not change the group." | `
                        ConvertTo-ErrorRecord -ErrorCategory InvalidArgument))
        }
    }
    Process {
        $groupId = $Group | Resolve-TeamViewerGroupId
        $resourceUri = "$(Get-TeamViewerApiUri)/groups/$groupId"

        if ($PSCmdlet.ShouldProcess($groupId, "Update group")) {
            Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $resourceUri `
                -Method Put `
                -ContentType "application/json; charset=utf-8" `
                -Body ([System.Text.Encoding]::UTF8.GetBytes(($body | ConvertTo-Json))) `
                -WriteErrorTo $PSCmdlet | `
                Out-Null
        }
    }
}



function Set-TeamViewerManagedDevice {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedDeviceId } )]
        [Alias("DeviceId")]
        [object]
        $Device,

        [Alias("Alias")]
        [string]
        $Name,

        [ValidateScript( { $_ | Resolve-TeamViewerPolicyId } )]
        [Alias("PolicyId")]
        [object]
        $Policy,

        [ValidateScript( { $_ | Resolve-TeamViewerManagedGroupId } )]
        [Alias("ManagedGroupId")]
        [object]
        $ManagedGroup
    )
    Begin {
        $body = @{}

        if ($Name) {
            $body['name'] = $Name
        }
        if ($Policy) {
            $body['teamviewerPolicyId'] = $Policy | Resolve-TeamViewerPolicyId
        }
        elseif ($ManagedGroup) {
            $body['managedGroupId'] = $ManagedGroup | Resolve-TeamViewerManagedGroupId
        }

        if ($Policy  -And $ManagedGroup) {
            $PSCmdlet.ThrowTerminatingError(
                ("The combination of parameters -Policy and -ManagedGroup is not allowed." | `
                        ConvertTo-ErrorRecord -ErrorCategory InvalidArgument))
        }

        if ($body.Count -eq 0) {
            $PSCmdlet.ThrowTerminatingError(
                ("The given input does not change the managed device." | `
                        ConvertTo-ErrorRecord -ErrorCategory InvalidArgument))
        }
    }
    Process {
        $deviceId = $Device | Resolve-TeamViewerManagedDeviceId
        $resourceUri = "$(Get-TeamViewerApiUri)/managed/devices/$deviceId"

        if ($PSCmdlet.ShouldProcess($Device.ToString(), "Change managed device entry")) {
            Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $resourceUri `
                -Method Put `
                -ContentType "application/json; charset=utf-8" `
                -Body ([System.Text.Encoding]::UTF8.GetBytes(($body | ConvertTo-Json))) `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop | `
                Out-Null
        }
    }
}



function Set-TeamViewerManagedGroup {
    [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'ByParameters')]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedGroupId })]
        [Alias("GroupId")]
        [Alias("Id")]
        [object]
        $Group,

        [Parameter(Mandatory = $true, ParameterSetName = 'ByParameters')]
        [string]
        $Name,

        [Parameter(Mandatory = $true, ParameterSetName = 'ByProperties')]
        [hashtable]
        $Property
    )
    Begin {
        # Warning suppresion doesn't seem to work.
        # See https://github.com/PowerShell/PSScriptAnalyzer/issues/1472
        $null = $Property

        $body = @{}
        switch ($PSCmdlet.ParameterSetName) {
            'ByParameters' {
                $body['name'] = $Name
            }
            'ByProperties' {
                @('name') | `
                    Where-Object { $Property[$_] } | `
                    ForEach-Object { $body[$_] = $Property[$_] }
            }
        }

        if ($body.Count -eq 0) {
            $PSCmdlet.ThrowTerminatingError(
                ("The given input does not change the managed group." | `
                        ConvertTo-ErrorRecord -ErrorCategory InvalidArgument))
        }
    }
    Process {
        $groupId = $Group | Resolve-TeamViewerManagedGroupId
        $resourceUri = "$(Get-TeamViewerApiUri)/managed/groups/$groupId"

        if ($PSCmdlet.ShouldProcess($groupId, "Update managed group")) {
            Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $resourceUri `
                -Method Put `
                -ContentType "application/json; charset=utf-8" `
                -Body ([System.Text.Encoding]::UTF8.GetBytes(($body | ConvertTo-Json))) `
                -WriteErrorTo $PSCmdlet | `
                Out-Null
        }
    }
}



function Set-TeamViewerManager {
    [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'Device_ByParameters')]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript( {
                if (($_.PSObject.TypeNames -contains 'TeamViewerPS.Manager') -And -Not $_.GroupId -And -Not $_.DeviceId) {
                    $PSCmdlet.ThrowTerminatingError(
                        ("Invalid manager object. Manager must be a group or device manager." | `
                                ConvertTo-ErrorRecord -ErrorCategory InvalidArgument))
                }
                $_ | Resolve-TeamViewerManagerId
            })]
        [Alias("ManagerId")]
        [Alias("Id")]
        [object]
        $Manager,

        [Parameter(ParameterSetName = 'Device_ByParameters')]
        [Parameter(ParameterSetName = 'Device_ByProperties')]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedDeviceId } )]
        [Alias("DeviceId")]
        [object]
        $Device,

        [Parameter(ParameterSetName = 'Group_ByParameters')]
        [Parameter(ParameterSetName = 'Group_ByProperties')]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedGroupId })]
        [Alias("GroupId")]
        [object]
        $Group,

        [Parameter(ParameterSetName = 'Device_ByParameters')]
        [Parameter(ParameterSetName = 'Group_ByParameters')]
        [AllowEmptyCollection()]
        [string[]]
        $Permissions,

        [Parameter(Mandatory = $true, ParameterSetName = 'Device_ByProperties')]
        [Parameter(Mandatory = $true, ParameterSetName = 'Group_ByProperties')]
        [hashtable]
        $Property
    )
    Begin {
        # Warning suppresion doesn't seem to work.
        # See https://github.com/PowerShell/PSScriptAnalyzer/issues/1472
        $null = $Property

        $body = @{}
        switch -Wildcard ($PSCmdlet.ParameterSetName) {
            '*ByParameters' {
                $body['permissions'] = @($Permissions)
            }
            '*ByProperties' {
                @('permissions') | `
                    Where-Object { $Property[$_] } | `
                    ForEach-Object { $body[$_] = $Property[$_] }
            }
        }

        if ($body.Count -eq 0) {
            $PSCmdlet.ThrowTerminatingError(
                ("The given input does not change the manager." | `
                        ConvertTo-ErrorRecord -ErrorCategory InvalidArgument))
        }
    }
    Process {
        $deviceId = $null
        $groupId = $null
        if ($Manager.PSObject.TypeNames -contains 'TeamViewerPS.Manager') {
            if ($Device -Or $Group) {
                $PSCmdlet.ThrowTerminatingError(
                    ("Device or Group parameter must not be specified if a [TeamViewerPS.Manager] object is given." | `
                            ConvertTo-ErrorRecord -ErrorCategory InvalidArgument))
            }
            if ($Manager.DeviceId) {
                $deviceId = $Manager.DeviceId
            }
            elseif ($Manager.GroupId) {
                $groupId = $Manager.GroupId
            }
        }
        elseif ($Device) {
            $deviceId = $Device | Resolve-TeamViewerManagedDeviceId
        }
        elseif ($Group) {
            $groupId = $Group | Resolve-TeamViewerManagedGroupId
        }
        else {
            $PSCmdlet.ThrowTerminatingError(
                ("Device or Group parameter must be specified if no [TeamViewerPS.Manager] object is given." | `
                        ConvertTo-ErrorRecord -ErrorCategory InvalidArgument))
        }

        $managerId = $Manager | Resolve-TeamViewerManagerId
        if ($deviceId) {
            $resourceUri = "$(Get-TeamViewerApiUri)/managed/devices/$deviceId/managers/$managerId"
            $processMessage = "Update managed device manager"
        }
        elseif ($groupId) {
            $resourceUri = "$(Get-TeamViewerApiUri)/managed/groups/$groupId/managers/$managerId"
            $processMessage = "Update managed group manager"
        }

        if ($PSCmdlet.ShouldProcess($managerId, $processMessage)) {
            Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $resourceUri `
                -Method Put `
                -ContentType "application/json; charset=utf-8" `
                -Body ([System.Text.Encoding]::UTF8.GetBytes(($body | ConvertTo-Json))) `
                -WriteErrorTo $PSCmdlet | `
                Out-Null
        }
    }
}



function Set-TeamViewerPolicy {
    [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'ByParameters')]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerPolicyId } )]
        [Alias('PolicyId')]
        [object]
        $Policy,

        [Parameter(ParameterSetName = 'ByParameters')]
        [string]
        $Name,

        [Parameter(ParameterSetName = 'ByParameters')]
        [object[]]
        $Settings,

        [Parameter(Mandatory = $true, ParameterSetName = 'ByProperties')]
        [hashtable]
        $Property
    )
    # Warning suppresion doesn't seem to work.
    # See https://github.com/PowerShell/PSScriptAnalyzer/issues/1472
    $null = $Property

    $body = @{}
    switch ($PSCmdlet.ParameterSetName) {
        'ByParameters' {
            if ($Name) {
                $body['name'] = $Name
            }
            if ($Settings) {
                $body['settings'] = $Settings
            }
        }
        'ByProperties' {
            @('name', 'settings') | `
                Where-Object { $Property[$_] } | `
                ForEach-Object { $body[$_] = $Property[$_] }
        }
    }

    if ($body.Count -eq 0) {
        $PSCmdlet.ThrowTerminatingError(
            ("The given input does not change the policy." | `
                    ConvertTo-ErrorRecord -ErrorCategory InvalidArgument))
    }

    $policyId = $Policy | Resolve-TeamViewerPolicyId
    $resourceUri = "$(Get-TeamViewerApiUri)/teamviewerpolicies/$policyId"

    if ($PSCmdlet.ShouldProcess($policyId, "Update policy")) {
        Invoke-TeamViewerRestMethod `
            -ApiToken $ApiToken `
            -Uri $resourceUri `
            -Method Put `
            -ContentType "application/json; charset=utf-8" `
            -Body ([System.Text.Encoding]::UTF8.GetBytes(($body | ConvertTo-Json -Depth 25))) `
            -WriteErrorTo $PSCmdlet | `
            Out-Null
    }
}



$global:TeamViewerProxyUriSet = $null

function Set-TeamViewerPSProxy {
    [CmdletBinding(SupportsShouldProcess =$true)]
    param (
        [Parameter(Mandatory=$true)]
        [Uri]
        $ProxyUri
    )

    if($PSCmdlet.ShouldProcess($ProxyUri,"Sets proxy for WebAPI")){
    $global:TeamViewerProxyUriSet = $ProxyUri
    $global:TeamViewerProxyUriRemoved = $false
    $global:TeamViewerProxyUriRemoved | Out-Null

    [Environment]::SetEnvironmentVariable("TeamViewerProxyUri", $ProxyUri, "User")

    Write-Output "Proxy set to $TeamViewerProxyUriSet"
    }
}




function Set-TeamViewerUser {
    [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'ByParameters')]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerUserId } )]
        [Alias("UserId")]
        [Alias("Id")]
        [object]
        $User,

        [Parameter(ParameterSetName = 'ByParameters')]
        [boolean]
        $Active,

        [Parameter(ParameterSetName = 'ByParameters')]
        [Alias('EmailAddress')]
        [string]
        $Email,

        [Parameter(ParameterSetName = 'ByParameters')]
        [Alias('DisplayName')]
        [string]
        $Name,

        [Parameter(ParameterSetName = 'ByParameters')]
        [securestring]
        $Password,

        [Parameter(ParameterSetName = 'ByParameters')]
        [securestring]
        $SsoCustomerIdentifier,

        [Parameter(ParameterSetName = 'ByParameters')]
        [array]
        $Permissions,

        [Parameter(Mandatory = $true, ParameterSetName = 'ByProperties')]
        [hashtable]
        $Property
    )

    $body = @{}
    switch ($PSCmdlet.ParameterSetName) {
        'ByParameters' {
            if ($PSBoundParameters.ContainsKey('Active')) {
                $body['active'] = $Active
            }
            if ($Email) {
                $body['email'] = $Email
            }
            if ($Name) {
                $body['name'] = $Name
            }
            if ($Password) {
                $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password)
                $body['password'] = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)
                [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr) | Out-Null
            }
            if ($SsoCustomerIdentifier) {
                $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SsoCustomerIdentifier)
                $body['sso_customer_id'] = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)
                [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr) | Out-Null
            }
            if ($Permissions) {
                $body['permissions'] = $Permissions -join ','
            }
        }
        'ByProperties' {
            @('active', 'email', 'name', 'password', 'sso_customer_id', 'permissions') | `
                Where-Object { $Property[$_] } | `
                ForEach-Object { $body[$_] = $Property[$_] }
        }
    }

    if ($body.Count -eq 0) {
        $PSCmdlet.ThrowTerminatingError(
            ("The given input does not change the user." | `
                    ConvertTo-ErrorRecord -ErrorCategory InvalidArgument))
    }

    $userId = Resolve-TeamViewerUserId -User $User
    $resourceUri = "$(Get-TeamViewerApiUri)/users/$userId"

    if ($PSCmdlet.ShouldProcess($userId, "Update user profile")) {
        Invoke-TeamViewerRestMethod `
            -ApiToken $ApiToken `
            -Uri $resourceUri `
            -Method Put `
            -ContentType "application/json; charset=utf-8" `
            -Body ([System.Text.Encoding]::UTF8.GetBytes(($body | ConvertTo-Json))) `
            -WriteErrorTo $PSCmdlet | `
            Out-Null
    }
}



function Set-TeamViewerUserGroup {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerUserGroupId } )]
        [Alias("UserGroupId")]
        [Alias("Id")]
        [object]
        $UserGroup,

        [Parameter(Mandatory = $true)]
        [Alias("UserGroupName")]
        [string]
        $Name
    )
    Begin {
        $id = $UserGroup | Resolve-TeamViewerUserGroupId
        $resourceUri = "$(Get-TeamViewerApiUri)/usergroups/$id"
        $body = @{ name = $Name }
    }
    Process {
        if ($PSCmdlet.ShouldProcess($UserGroup.ToString(), "Change user group")) {
            $response = Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $resourceUri `
                -Method Put `
                -ContentType "application/json; charset=utf-8" `
                -Body ([System.Text.Encoding]::UTF8.GetBytes(($body | ConvertTo-Json))) `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop
            Write-Output ($response | ConvertTo-TeamViewerUserGroup)
        }
    }
}




function Set-TeamViewerUserRole {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true )]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [Alias('UserRoleName')]
        [string]
        $Name,

        [Parameter(Mandatory = $false)]
        [AllowEmptyCollection()]
        [object[]]
        $Permissions,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerUserRoleId } )]
        [Alias('UserRole')]
        [object]
        $UserRoleId
    )
    Begin {
        $resourceUri = "$(Get-TeamViewerApiUri)/userroles"
        $body = @{
            Name        = $Name
            Permissions = @()
            UserRoleId  = $UserRoleId

        }
        if ($Permissions) {
            $body.Permissions = @($Permissions)
        }
    }
    Process {
        if ($PSCmdlet.ShouldProcess($Name, 'Update User Role')) {
            $response = Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $resourceUri `
                -Method Put `
                -ContentType 'application/json; charset=utf-8' `
                -Body ([System.Text.Encoding]::UTF8.GetBytes(($body | ConvertTo-Json))) `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop

            $result = $response
            Write-Output $result
        }
    }

}



function Start-TeamViewerService {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param()

    if ($PSCmdlet.ShouldProcess("TeamViewer service")) {
        switch (Get-OperatingSystem) {
            'Windows' {
                Start-Service -Name (Get-TeamViewerServiceName)
            }
            'Linux' {
                Invoke-ExternalCommand /opt/teamviewer/tv_bin/script/teamviewer daemon start
            }
        }
    }
}



function Stop-TeamViewerService {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param()

    if ($PSCmdlet.ShouldProcess("TeamViewer service")) {
        switch (Get-OperatingSystem) {
            'Windows' {
                Stop-Service -Name (Get-TeamViewerServiceName)
            }
            'Linux' {
                Invoke-ExternalCommand /opt/teamviewer/tv_bin/script/teamviewer daemon stop
            }
        }
    }
}



function Test-TeamViewerConnectivity {
    param(
        [Parameter()]
        [switch]
        $Quiet
    )

    $endpoints = @(
        @{ Hostname = 'webapi.teamviewer.com'; TcpPort = 443; }
        @{ Hostname = 'login.teamviewer.com'; TcpPort = 443; }
        @{ Hostname = 'meeting.teamviewer.com'; TcpPort = 443; }
        @{ Hostname = 'sso.teamviewer.com'; TcpPort = 443; }
        @{ Hostname = 'download.teamviewer.com'; TcpPort = 443; }
        @{ Hostname = 'configdl.teamviewer.com'; TcpPort = 443; }
        @{ Hostname = 'get.teamviewer.com'; TcpPort = 443; }
        @{ Hostname = 'go.teamviewer.com'; TcpPort = 443; }
        @{ Hostname = 'client.teamviewer.com'; TcpPort = 443; }
        @{ Hostname = 'feedbackservice.teamviewer.com'; TcpPort = 443; }
        @{ Hostname = 'remotescriptingstorage.blob.core.windows.net'; TcpPort = 443; }
        @{ Hostname = 'chatlivestorage.blob.core.windows.net'; TcpPort = 443; }
    )
    1..16 | ForEach-Object {
        $endpoints += @{ Hostname = "router$_.teamviewer.com"; TcpPort = (5938, 443, 80) }
    }

    $results = $endpoints | ForEach-Object {
        $endpoint = $_
        $portSucceeded = $endpoint.TcpPort | Where-Object {
            Write-Verbose "Checking endpoint $($endpoint.Hostname) on port $_"
            Test-TcpConnection -Hostname $endpoint.Hostname -Port $_
        } | Select-Object -First 1
        $endpoint.Succeeded = [bool]$portSucceeded
        $endpoint.TcpPort = if ($endpoint.Succeeded) { $portSucceeded } else { $endpoint.TcpPort }
        return $endpoint
    }

    if ($Quiet) {
        ![bool]($results | Where-Object { -Not $_.Succeeded })
    }
    else {
        $results | `
            ForEach-Object { New-Object PSObject -Property $_ } | `
            Select-Object -Property Hostname, TcpPort, Succeeded | `
            Sort-Object Hostname
    }
}



function Test-TeamViewerInstallation {
    if (Get-TeamViewerInstallationDirectory) {
        return $true
    }
    else {
        return $false
    }
}



function Unpublish-TeamViewerGroup {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerGroupId } )]
        [Alias("GroupId")]
        [object]
        $Group,

        [Parameter(Mandatory = $true)]
        [Alias("UserId")]
        [object[]]
        $User
    )

    $groupId = $Group | Resolve-TeamViewerGroupId
    $userIds = $User | Resolve-TeamViewerUserId
    $resourceUri = "$(Get-TeamViewerApiUri)/groups/$groupId/unshare_group"
    $body = @{users = @($userIds) }

    if ($PSCmdlet.ShouldProcess($userids, "Remove group share")) {
        Invoke-TeamViewerRestMethod `
            -ApiToken $ApiToken `
            -Uri $resourceUri `
            -Method Post `
            -ContentType "application/json; charset=utf-8" `
            -Body ([System.Text.Encoding]::UTF8.GetBytes(($body | ConvertTo-Json))) `
            -WriteErrorTo $PSCmdlet | `
            Out-Null
    }
}



