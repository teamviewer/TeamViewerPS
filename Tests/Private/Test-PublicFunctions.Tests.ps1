BeforeAll {
    $Script:Module_RootPath = (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..'))
    $Script:Module_FilePath = (Get-ChildItem -Path (Join-Path -Path $Module_RootPath -ChildPath 'Cmdlets') -Filter '*.psm1' -File).FullName
    $Script:Module_Name = (Split-Path -Path $Module_FilePath -Leaf).Replace('.psm1', '')
    $Script:Module_ManifestFilePath = (Get-ChildItem -Path (Join-Path -Path $Module_RootPath -ChildPath 'Cmdlets') -Filter '*.psd1' -File).FullName
    $Script:Module_Manifest = Test-ModuleManifest -Path $Module_ManifestFilePath -ErrorAction Stop
    $Script:Module_PubFunctionNames = (Get-ChildItem -Path (Join-Path -Path $Module_RootPath -ChildPath 'Cmdlets\Public') -Filter '*.ps1' -File | Select-Object BaseName)
}

Context 'Test-PublicFunctions' {
    $Test_Case = $Module_PubFunctionNames | ForEach-Object { @{ PubFunction = $_ } }

    It 'Public function should be in manifest' -TestCases $Test_Case {
        param($PubFunction)

        $Manifest_PubFunctions = $Module_Manifest.ExportedFunctions.Keys

        $PubFunction -in $Manifest_PubFunctions | Should -Be $true
    }

    It 'Number of public functions compared to manifest file' {
        $PubFunction_Count = Get-Command -Module $Module_Name -CommandType Function | Measure-Object | Select-Object -ExpandProperty Count
        $Manifest_PubFuncCount = $Manifest.ExportedFunctions.Count

        $PubFunction_Count | Should -Be $Manifest_PubFuncCount
    }

    It 'Number of public functions compared to files' {
        $PubFunction_Count = Get-Command -Module $Module_Name -CommandType Function | Measure-Object | Select-Object -ExpandProperty Count

        $PubFunction_Count | Should -Be $Module_PubFunctionNames.Count
    }
}
