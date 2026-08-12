BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Test-TeamViewerConnectivity.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    Mock Test-NetConnection { $true }
}

Describe 'Test-TeamViewerConnectivity' {

    It 'Should check TCP connections to various endpoints' {
        Test-TeamViewerConnectivity

        Should -Invoke Test-NetConnection -Times 1 -Scope It -ParameterFilter {
            $ComputerName -eq 'webapi.teamviewer.com' -and $Port -eq 443
        }
        Should -Invoke Test-NetConnection -Times 1 -Scope It -ParameterFilter {
            $ComputerName -eq 'sso.teamviewer.com' -and $Port -eq 443
        }
        Should -Invoke Test-NetConnection -Times 1 -Scope It -ParameterFilter {
            $ComputerName -eq 'router1.teamviewer.com' -and $Port -eq 5938
        }
    }

    It 'Should check fallback ports' {
        Mock Test-NetConnection -ParameterFilter {
            $ComputerName -eq 'router1.teamviewer.com' -and $Port -eq 5938
        } { $false }

        Test-TeamViewerConnectivity

        Should -Invoke Test-NetConnection -Times 1 -Scope It -ParameterFilter {
            $ComputerName -eq 'router1.teamviewer.com' -and $Port -eq 5938
        }
        Should -Invoke Test-NetConnection -Times 1 -Scope It -ParameterFilter {
            $ComputerName -eq 'router1.teamviewer.com' -and $Port -eq 443
        }
        Should -Invoke Test-NetConnection -Times 0 -Scope It -ParameterFilter {
            $ComputerName -eq 'router2.teamviewer.com' -and $Port -eq 443
        }
    }

    It 'Should return the port on successful check' {
        $result = Test-TeamViewerConnectivity
        $routerResult = $result | Where-Object { $_.Hostname -eq 'router1.teamviewer.com' }
        $routerResult | Should -Not -BeNullOrEmpty
        $routerResult.Succeeded | Should -BeTrue
        $routerResult.TcpPort | Should -Be 5938
    }

    It 'Should use the next fallback port when the first router port fails' {
        Mock Test-NetConnection -ParameterFilter {
            $ComputerName -eq 'router1.teamviewer.com' -and $Port -eq 5938
        } { $false }

        Mock Test-NetConnection -ParameterFilter {
            $ComputerName -eq 'router1.teamviewer.com' -and $Port -eq 443
        } { $false }

        $result = Test-TeamViewerConnectivity
        $routerResult = $result | Where-Object { $_.Hostname -eq 'router1.teamviewer.com' }

        Should -Invoke Test-NetConnection -Times 1 -Scope It -ParameterFilter {
            $ComputerName -eq 'router1.teamviewer.com' -and $Port -eq 80
        }

        $routerResult.Succeeded | Should -BeTrue
        $routerResult.TcpPort | Should -Be 80
    }

    It 'Should return all tried ports on failed check' {
        Mock Test-NetConnection -ParameterFilter {
            $ComputerName -eq 'router1.teamviewer.com'
        } { $false }

        $result = Test-TeamViewerConnectivity
        $routerResult = $result | Where-Object { $_.Hostname -eq 'router1.teamviewer.com' }
        $routerResult | Should -Not -BeNullOrEmpty
        $routerResult.Succeeded | Should -BeFalse
        $routerResult.TcpPort | Should -Be @(5938, 443, 80)
    }

    It 'Should return the overall result for the -Quiet parameter' {
        $result = Test-TeamViewerConnectivity -Quiet
        $result | Should -BeTrue
        $result | Should -BeOfType [bool]
    }

    It 'Should return false if one of the checks failed' {
        Mock Test-NetConnection -ParameterFilter {
            $ComputerName -eq 'router1.teamviewer.com'
        } { $false }

        $result = Test-TeamViewerConnectivity -Quiet
        $result | Should -BeFalse
        $result | Should -BeOfType [bool]
    }

    It 'Should return all expected services and output properties' {
        $result = Test-TeamViewerConnectivity

        $result.Count | Should -Be 31
        $result[0].PSObject.Properties.Name | Should -Contain 'Hostname'
        $result[0].PSObject.Properties.Name | Should -Contain 'TcpPort'
        $result[0].PSObject.Properties.Name | Should -Contain 'Succeeded'
    }

    It 'Should return hostnames sorted in ascending order' {
        $result = Test-TeamViewerConnectivity
        $hostnames = $result.Hostname

        $hostnames | Should -Be ($hostnames | Sort-Object)
    }
}
