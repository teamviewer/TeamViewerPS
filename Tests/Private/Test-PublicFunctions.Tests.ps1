BeforeDiscovery {
    $Script:Module_RootPath = (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..'))
    $Script:Module_CmdletsPath = Join-Path -Path $Module_RootPath -ChildPath 'Cmdlets'
    $Script:Module_ManifestFilePath = (Get-ChildItem -Path $Module_CmdletsPath -Filter '*.psd1' -File).FullName
    $Script:Module_PublFunctionNames = @(Get-ChildItem -Path (Join-Path -Path $Module_CmdletsPath -ChildPath 'Public') -Filter '*.ps1' -File | Select-Object -ExpandProperty BaseName | Sort-Object -Unique)

    $Script:PublicFunctionTestCases = $Module_PublFunctionNames | ForEach-Object {
        @{ FunctionName = $_ }
    }
}

BeforeAll {
    {
        $Script:ImportedModule = Import-Module -Name $Module_ManifestFilePath -Force -PassThru -ErrorAction Stop
    } | Should -Not -Throw

    $Script:ExportedFunctionNames = @($ImportedModule.ExportedFunctions.Keys | Sort-Object -Unique)
}

Describe 'Test-PublicFunctions' {
    It 'Discovers public function files' {
        $Module_PublFunctionNames | Should -Not -BeNullOrEmpty
    }

    It 'Public function has a corresponding test file: <FunctionName>' -TestCases $PublicFunctionTestCases {
        param(
            [string]$FunctionName
        )

        Test-Path -Path (Join-Path -Path (Join-Path -Path $Module_RootPath -ChildPath 'Tests\Public') -ChildPath "$FunctionName.Tests.ps1") | Should -BeTrue
    }

    It 'Public function has a corresponding help file: <FunctionName>' -TestCases $PublicFunctionTestCases {
        param(
            [string]$FunctionName
        )

        Test-Path -Path (Join-Path -Path (Join-Path -Path $Module_RootPath -ChildPath 'Docs\Help') -ChildPath "$FunctionName.md") | Should -BeTrue
    }

    It 'Every public function file is exported by module' {
        $missingExports = @($Module_PublFunctionNames | Where-Object { $_ -notin $ExportedFunctionNames })

        $missingExports | Should -BeNullOrEmpty -Because "Public functions missing from module exports: $($missingExports -join ', ')"
    }
}

AfterAll {
    if (Get-Module -Name $ImportedModule.Name) {
        Remove-Module -Name $ImportedModule.Name -Force
    }
}
