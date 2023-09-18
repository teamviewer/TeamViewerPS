BeforeAll {
    . "$PSScriptRoot/../../Docs/Cmdlets/Public/Test-TeamViewerConnectivity.ps1"

    @(Get-ChildItem -Path "$PSScriptRoot/../../Docs/Cmdlets/Private/*.ps1") | `
        ForEach-Object { . $_.FullName }

    Mock Test-TcpConnection { $true }
}

Describe 'Test-TeamViewerConnectivity' {

    It 'Should check TCP connections to various endpoints' {
        Test-TeamViewerConnectivity

        Assert-MockCalled Test-TcpConnection -Times 1 -Scope It -ParameterFilter {
            $Hostname -eq 'webapi.teamviewer.com' -And $Port -eq 443
        }
        Assert-MockCalled Test-TcpConnection -Times 1 -Scope It -ParameterFilter {
            $Hostname -eq 'sso.teamviewer.com' -And $Port -eq 443
        }
        Assert-MockCalled Test-TcpConnection -Times 1 -Scope It -ParameterFilter {
            $Hostname -eq 'router1.teamviewer.com' -And $Port -eq 5938
        }
    }

    It 'Should check fallback ports' {
        Mock Test-TcpConnection -ParameterFilter {
            $Hostname -eq 'router1.teamviewer.com' -And $Port -eq 5938
        } { $false }

        Test-TeamViewerConnectivity

        Assert-MockCalled Test-TcpConnection -Times 1 -Scope It -ParameterFilter {
            $Hostname -eq 'router1.teamviewer.com' -And $Port -eq 5938
        }
        Assert-MockCalled Test-TcpConnection -Times 1 -Scope It -ParameterFilter {
            $Hostname -eq 'router1.teamviewer.com' -And $Port -eq 443
        }
        Assert-MockCalled Test-TcpConnection -Times 0 -Scope It -ParameterFilter {
            $Hostname -eq 'router2.teamviewer.com' -And $Port -eq 443
        }
    }

    It 'Should return the port on successful check' {
        $result = Test-TeamViewerConnectivity
        $routerResult = $result | Where-Object { $_.Hostname -eq 'router1.teamviewer.com' }
        $routerResult | Should -Not -BeNullOrEmpty
        $routerResult.Succeeded | Should -BeTrue
        $routerResult.TcpPort | Should -Be 5938
    }

    It 'Should return all tried ports on failed check' {
        Mock Test-TcpConnection -ParameterFilter {
            $Hostname -eq 'router1.teamviewer.com'
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
        Mock Test-TcpConnection -ParameterFilter {
            $Hostname -eq 'router1.teamviewer.com'
        } { $false }

        $result = Test-TeamViewerConnectivity -Quiet
        $result | Should -BeFalse
        $result | Should -BeOfType [bool]
    }
}
