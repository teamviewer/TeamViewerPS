BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\TeamViewerPS.Types.ps1"
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerConnectionReport.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | `
        ForEach-Object { . $_.FullName }

    $testApiToken = [securestring]@{}
    $null = $testApiToken

    Mock Get-TeamViewerApiUri { '//unit.test' }
    Mock Invoke-TeamViewerRestMethod { @{
            records = @(
                @{
                    id                   = '0755a8dd-df19-4ea7-af47-cabb6b2a97e4'
                    userid               = 'u1234'
                    username             = 'test-user1'
                    deviceid             = 'd111'
                    devicename           = 'test-device1'
                    start_date           = '2017-02-03T14:10:50Z'
                    end_date             = '2017-02-03T14:11:01Z'
                    support_session_type = 1
                },
                @{
                    id                   = '5ae6d2a9-57e9-4c62-b236-280390954b6f'
                    userid               = 'u5678'
                    username             = 'test-user2'
                    deviceid             = 'd222'
                    devicename           = 'test-device2'
                    start_date           = '2017-02-03T14:10:50Z'
                    end_date             = '2017-02-03T14:11:01Z'
                    support_session_type = 1
                }
            )
        } }
}

Describe 'Get-TeamViewerConnectionReport' {
    It 'Should call the correct API endpoint to list connection reports' {
        Get-TeamViewerConnectionReport -ApiToken $testApiToken
        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $ApiToken -eq $testApiToken -And `
                $Uri -eq '//unit.test/reports/connections' -And `
                $Method -eq 'Get' }
    }

    It 'Should return ConnectionReport objects' {
        $result = Get-TeamViewerConnectionReport -ApiToken $testApiToken
        $result | Should -HaveCount 2
        $result[0].PSObject.TypeNames | Should -Contain 'TeamViewerPS.ConnectionReport'
    }

    It 'Should fetch consecutive pages' {
        Mock Invoke-TeamViewerRestMethod { @{
                records     = @(
                    @{
                        id                   = '0755a8dd-df19-4ea7-af47-cabb6b2a97e4'
                        userid               = 'u1234'
                        username             = 'test-user1'
                        deviceid             = 'd111'
                        devicename           = 'test-device1'
                        start_date           = '2017-02-03T14:10:50Z'
                        end_date             = '2017-02-03T14:11:01Z'
                        support_session_type = 1
                    }
                )
                next_offset = '0755a8dd-df19-4ea7-af47-cabb6b2a97e4'
            } }
        Mock Invoke-TeamViewerRestMethod { @{
                records     = @(
                    @{
                        id                   = '5ae6d2a9-57e9-4c62-b236-280390954b6f'
                        userid               = 'u5678'
                        username             = 'test-user2'
                        deviceid             = 'd222'
                        devicename           = 'test-device2'
                        start_date           = '2017-02-03T14:10:50Z'
                        end_date             = '2017-02-03T14:11:01Z'
                        support_session_type = 1
                    }
                )
                next_offset = '5ae6d2a9-57e9-4c62-b236-280390954b6f'
            } } -ParameterFilter { $Body.offset_id -eq '0755a8dd-df19-4ea7-af47-cabb6b2a97e4' }
	        Mock Invoke-TeamViewerRestMethod { @{
                records = @(
                    @{
                        id                   = '018d007c-9faf-474a-b39a-4021251860e7'
                        userid               = 'u9012'
                        username             = 'test-user3'
                        deviceid             = 'd333'
                        devicename           = 'test-device3'
                        start_date           = '2017-02-03T14:10:50Z'
                        end_date             = '2017-02-03T14:11:01Z'
                        support_session_type = 1
                    }
                )
            } }  -ParameterFilter { $Body.offset_id -eq '5ae6d2a9-57e9-4c62-b236-280390954b6f' }


        $result = Get-TeamViewerConnectionReport -ApiToken $testApiToken
        $result | Should -HaveCount 3
        Assert-MockCalled Invoke-TeamViewerRestMethod -Times 3 -Scope It
    }

    Context 'Filtering' {
        BeforeAll {
            $mockArgs = @{}
            Mock Invoke-TeamViewerRestMethod { $mockArgs.Body = $Body; @{ records = @() } }
        }

        It 'Should allow to filter by username' {
            Get-TeamViewerConnectionReport -ApiToken $testApiToken -UserName 'test-user1'
            Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It
            $mockArgs.Body.username | Should -Be 'test-user1'
        }

        It 'Should allow to filter by userid' {
            Get-TeamViewerConnectionReport -ApiToken $testApiToken -UserId 'u1234'
            Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It
            $mockArgs.Body.userid | Should -Be 'u1234'
        }

        It 'Should allow to filter by groupid' {
            Get-TeamViewerConnectionReport -ApiToken $testApiToken -GroupId 'g1234'
            Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It
            $mockArgs.Body.groupid | Should -Be 'g1234'
        }

        It 'Should allow to filter by device name' {
            Get-TeamViewerConnectionReport -ApiToken $testApiToken -DeviceName 'test-device1'
            Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It
            $mockArgs.Body.devicename | Should -Be 'test-device1'
        }

        It 'Should allow to filter by deviceid' {
            Get-TeamViewerConnectionReport -ApiToken $testApiToken -DeviceId 111
            Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It
            $mockArgs.Body.deviceid | Should -Be '111'
        }

        It 'Should allow to filter by session code' {
            Get-TeamViewerConnectionReport -ApiToken $testApiToken -SessionCode 's112233'
            Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It
            $mockArgs.Body.session_code | Should -Be 's112233'
        }

        It 'Should allow to filter for entries with session code' {
            Get-TeamViewerConnectionReport -ApiToken $testApiToken -WithSessionCode
            Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It
            $mockArgs.Body.has_code | Should -Be $true
        }

        It 'Should allow to filter for entries without session code' {
            Get-TeamViewerConnectionReport -ApiToken $testApiToken -WithoutSessionCode
            Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It
            $mockArgs.Body.has_code | Should -Be $false
        }

        It 'Should allow to filter by support session type' {
            Get-TeamViewerConnectionReport -ApiToken $testApiToken -SupportSessionType 'RemoteSupportActiveSdk'
            Assert-MockCalled Invoke-TeamViewerRestMethod -Times 1 -Scope It
            $mockArgs.Body.support_session_type | Should -Be 3
        }
    }

    Context 'Time frame' {
        BeforeAll {
            $testStartDate = Get-Date
            $testEndDate = $testStartDate.AddDays(1)
            $null = $testEndDate

            $mockArgs = @{}
            Mock Invoke-TeamViewerRestMethod { $mockArgs.Body = $Body; @{ records = @() } }

            function Get-TestStartEndDate {
                $mockArgs.Body | Should -Not -BeNullOrEmpty
                $body = $mockArgs.Body
                $body.from_date | Should -Not -BeNullOrEmpty
                $body.to_date | Should -Not -BeNullOrEmpty
                $startDate = [System.DateTime]::ParseExact($body.from_date, 'yyyy-MM-ddTHH:mm:ssZ', [CultureInfo]::InvariantCulture)
                $endDate = [System.DateTime]::ParseExact($body.to_date, 'yyyy-MM-ddTHH:mm:ssZ', [CultureInfo]::InvariantCulture)
                return @{
                    StartDate = $startDate
                    EndDate   = $endDate
                    Diff      = New-TimeSpan -Start $startDate -End $endDate
                }
            }
        }

        It 'Should allow to specify an absolute start and end time' {
            Get-TeamViewerConnectionReport -ApiToken $testApiToken `
                -StartDate $testStartDate -EndDate $testEndDate
            $dates = Get-TestStartEndDate
            $dates.StartDate | Should -Be $testStartDate.AddTicks(-1 * ($testStartDate.Ticks % [TimeSpan]::TicksPerSecond))
            $dates.EndDate | Should -Be $testEndDate.AddTicks(-1 * ($testEndDate.Ticks % [TimeSpan]::TicksPerSecond))
        }

        It 'Should allow to set a start date months in the past' {
            Get-TeamViewerConnectionReport -ApiToken $testApiToken -Months 3
            $dates = Get-TestStartEndDate
            $dates.Diff.TotalDays | Should -BeLessOrEqual (3 * 31)
            $dates.Diff.TotalDays | Should -BeGreaterOrEqual (3 * 28)
        }

        It 'Should allow to set a start date days in the past' {
            Get-TeamViewerConnectionReport -ApiToken $testApiToken -Days 7
            $dates = Get-TestStartEndDate
            $dates.Diff.TotalDays | Should -Be 7
        }

        It 'Should allow to set a start date hours in the past' {
            Get-TeamViewerConnectionReport -ApiToken $testApiToken -Hours 12
            $dates = Get-TestStartEndDate
            $dates.Diff.TotalHours | Should -Be 12
        }

        It 'Should allow to set a start date minutes in the past' {
            Get-TeamViewerConnectionReport -ApiToken $testApiToken -Minutes 45
            $dates = Get-TestStartEndDate
            $dates.Diff.TotalMinutes | Should -Be 45
        }

        It 'Should not restrict timeframe if no start and end date are given' {
            Get-TeamViewerConnectionReport -ApiToken $testApiToken
            $body = $mockArgs.Body
            $body.from_date | Should -BeNullOrEmpty
            $body.to_date | Should -BeNullOrEmpty
        }
    }
}