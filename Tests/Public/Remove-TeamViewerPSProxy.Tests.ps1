
BeforeAll {
    . "$PSScriptRoot/../../docs/Cmdlets/Public/Remove-TeamViewerPSProxy.ps1"
    @(Get-ChildItem -Path "$PSScriptRoot/../../docs/Cmdlets/Private/*.ps1") | `
        ForEach-Object { . $_.FullName }

        Mock -CommandName 'Remove-TeamViewerPSProxy' -MockWith {
            $global:TeamViewerProxyUriSet = $null
            $global:TeamViewerProxyUriSet | Out-Null
            $global:TeamViewerProxyUriRemoved = $true
            $global:TeamViewerProxyUriRemoved | Out-Null
            [Environment]::SetEnvironmentVariable('TVProxyUri', '', 'User')
        }
}

Describe "Remove-TeamViewerPSProxy" {
    Context "When removing the proxy URI" {
        It "Should set the global variable TeamViewerProxyUriRemoved to true" {
            Remove-TeamViewerPSProxy
            $global:TeamViewerProxyUriRemoved | Should -Be $true
        }

        It "Should remove the environment variable TeamViewerProxyUri" {
            Remove-TeamViewerPSProxy
            [Environment]::GetEnvironmentVariable("TVProxyUri", "User") | Should -BeNullOrEmpty
        }
    }
}
