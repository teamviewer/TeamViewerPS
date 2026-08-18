BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerEventLog.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken
    $mockArgs = @{}

    Mock Get-TeamViewerApiUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod {
        $mockArgs.Body = $Body
        @{
            AuditEvents = @(
                @{ Name = 'Event1' },
                @{ Name = 'Event2' },
                @{ Name = 'Event3' },
                @{ Name = 'Event4' },
                @{ Name = 'Event5' }
            )
        } }
}

Describe 'Get-TeamViewerEventLog' {
    It 'Should reject a negative limit' {
        { Get-TeamViewerEventLog -ApiToken $testApiToken -Limit -1 } | Should -Throw
    }

    It 'Should call the correct API endpoint to get audit-log events' {
        Get-TeamViewerEventLog -ApiToken $testApiToken

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -and $Uri -eq '//unit.test/EventLogging' -and $Method -eq 'Post' }
    }

    It 'Should return AuditEvent objects' {
        $Result = Get-TeamViewerEventLog -ApiToken $testApiToken
        $Result | Should -Not -BeNullOrEmpty
        $Result | Should -HaveCount 5
        $Result[0].PSObject.TypeNames | Should -Contain 'TeamViewerPS.AuditEvent'
    }

    It 'Should fetch consecutive pages' {
        Mock Invoke-TeamViewerRestMethod { @{
                ContinuationToken = 'abc'
                AuditEvents       = @(
                    @{ Name = 'Event1' },
                    @{ Name = 'Event2' },
                    @{ Name = 'Event3' },
                    @{ Name = 'Event4' },
                    @{ Name = 'Event5' }
                )
            } }

        Mock Invoke-TeamViewerRestMethod { @{
                ContinuationToken = 'foo'
                AuditEvents       = @(
                    @{ Name = 'Event6' },
                    @{ Name = 'Event7' }
                )
            } } -ParameterFilter {
            $Body -and `
            ([System.Text.Encoding]::UTF8.GetString($Body) | ConvertFrom-Json).ContinuationToken -eq 'abc'
        }

        Mock Invoke-TeamViewerRestMethod { @{
                ContinuationToken = $null
                AuditEvents       = @(
                    @{ Name = 'Event8' },
                    @{ Name = 'Event9' }
                )
            } } -ParameterFilter {
            $Body -and `
            ([System.Text.Encoding]::UTF8.GetString($Body) | ConvertFrom-Json).ContinuationToken -eq 'foo'
        }

        $Result = Get-TeamViewerEventLog -ApiToken $testApiToken
        $Result | Should -HaveCount 9

        Should -Invoke Invoke-TeamViewerRestMethod -Times 2 -Scope It
    }

    It 'Should filter by event names' {
        Get-TeamViewerEventLog -ApiToken $testApiToken -EventNames 'UserDeleted', 'UserGroupUpdated'

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $Body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $Body.EventNames | Should -HaveCount 2
        $Body.EventNames | Should -Contain 'UserDeleted'
        $Body.EventNames | Should -Contain 'UserGroupUpdated'
    }

    It 'Should filter by event types' {
        Get-TeamViewerEventLog -ApiToken $testApiToken -EventTypes 'CustomModules', 'Session'

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $Body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $Body.EventTypes | Should -HaveCount 2
        $Body.EventTypes | Should -Contain 'CustomModules'
        $Body.EventTypes | Should -Contain 'Session'
    }

    It 'Should forward additional filters' {
        Get-TeamViewerEventLog -ApiToken $testApiToken -AccountEmails 'foo@unit.test', 'bar@unit.test' -AffectedItem 'my item' -RemoteControlSessionId '6a5e870b-03d2-4e96-ac21-1d45c40c471b'

        $mockArgs.Body | Should -Not -BeNullOrEmpty
        $Body = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body) | ConvertFrom-Json
        $Body.AccountEmails | Should -HaveCount 2
        $Body.AccountEmails | Should -Be @('foo@unit.test', 'bar@unit.test')
        $Body.AffectedItem | Should -Be 'my item'
        $Body.RCSessionGuid | Should -Contain '6a5e870b-03d2-4e96-ac21-1d45c40c471b'
    }

    It 'Should optionally limit the number of returned results' {
        $Result = Get-TeamViewerEventLog -ApiToken $testApiToken -Limit 3
        $Result | Should -Not -BeNullOrEmpty
        $Result | Should -HaveCount 3
    }

    Context 'Start-End dates' {
        BeforeAll {
            function Get-TestStartEndDate {
                $mockArgs.Body | Should -Not -BeNullOrEmpty
                $BodyText = [System.Text.Encoding]::UTF8.GetString($mockArgs.Body)

                if ('System.Text.Json.JsonSerializer' -as [type]) {
                    # ConvertFrom-Json does some automatic datetime conversion.
                    # We don't want that here, so we parse manually.
                    $Body = [System.Text.Json.JsonSerializer]::Deserialize($BodyText, [hashtable])
                    $Body.StartDate | Should -Not -BeNullOrEmpty
                    $Body.EndDate | Should -Not -BeNullOrEmpty
                    $startDate = [System.DateTime]::ParseExact($Body.StartDate, 'yyyy-MM-ddTHH:mm:ssZ', [CultureInfo]::InvariantCulture)
                    $endDate = [System.DateTime]::ParseExact($Body.EndDate, 'yyyy-MM-ddTHH:mm:ssZ', [CultureInfo]::InvariantCulture)
                }
                else {
                    # we can only do the above check in .NET core and above
                    $Body = $BodyText | ConvertFrom-Json
                    $startDate = $Body.StartDate
                    $endDate = $Body.EndDate
                }

                $startDate | Should -BeLessThan $endDate

                return @{
                    StartDate = $startDate
                    EndDate   = $endDate
                    Diff      = New-TimeSpan -Start $startDate -End $endDate
                }
            }
        }

        It 'Should use relative dates by default' {
            Get-TeamViewerEventLog -ApiToken $testApiToken

            $dates = Get-TestStartEndDate
            $dates.Diff.TotalHours | Should -Be 1
        }

        It 'Should set start date months in the past' {
            Get-TeamViewerEventLog -ApiToken $testApiToken -Months 3

            $dates = Get-TestStartEndDate
            $dates.Diff.TotalDays | Should -BeLessOrEqual (3 * 31)
            $dates.Diff.TotalDays | Should -BeGreaterOrEqual (3 * 28)
        }

        It 'Should set start date days in the past' {
            Get-TeamViewerEventLog -ApiToken $testApiToken -Days 7

            $dates = Get-TestStartEndDate
            $dates.Diff.TotalDays | Should -Be 7
        }

        It 'Should set start date hours in the past' {
            Get-TeamViewerEventLog -ApiToken $testApiToken -Hours 12

            $dates = Get-TestStartEndDate
            $dates.Diff.TotalHours | Should -Be 12
        }

        It 'Should set start date minutes in the past' {
            Get-TeamViewerEventLog -ApiToken $testApiToken -Minutes 45

            $dates = Get-TestStartEndDate
            $dates.Diff.TotalMinutes | Should -Be 45
        }

        It 'Should set exact start-end dates' {
            Get-TeamViewerEventLog -ApiToken $testApiToken -StartDate '1999-12-31' -EndDate '2021-11-09'

            $dates = Get-TestStartEndDate
            $dates.StartDate | Should -Be ([datetime]'1999-12-31')
            $dates.EndDate | Should -Be ([datetime]'2021-11-09')
        }
    }
}
