BeforeAll {
    $Script:Module_RootPath = (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..'))
    $Script:Module_FilePath = (Get-ChildItem -Path (Join-Path -Path $Module_RootPath -ChildPath 'Cmdlets') -Filter '*.psm1' -File)
    $Script:Module_Name = (Get-ChildItem -Path $Module_FilePath -Filter '*.psm1' -File) -Replace '.psm1'
    $Script:Module_ManifestFilePath = (Join-Path -Path $Module_RootPath -ChildPath "Cmdlets\$Module_Name.psd1")
}

Context 'Test-ManifestFile' {
    It 'Valid module manifest file' {
        $Module_ManifestFilePath | Should -Exist

        {
            $Script:Module_Manifest = Test-ModuleManifest -Path $Module_ManifestFilePath -ErrorAction Stop
        } | Should -Not -Throw
    }

    It 'Valid manifest root module' {
        $Module_Manifest.RootModule | Should -Be "$Module_Name.psm1"
    }

    It 'Valid version check' {
        $Module_Manifest.Version -as [Version] | Should -Not -BeNullOrEmpty
    }

    It 'Valid manifest GUID' {
        $Module_Manifest.Guid | Should -Be 'd4e57325-dfd9-4391-8259-ce81d2aa7d48'
    }

    It 'Valid manifest author' {
        $Module_Manifest.Author | Should -Be 'TeamViewer Germany GmbH'
    }

    It 'Valid manifest company' {
        $Module_Manifest.CompanyName | Should -Be 'TeamViewer Germany GmbH'
    }

    It 'Valid manifest description' {
        $Module_Manifest.Description | Should -BeLike "$Module_Name*"
    }
}

<# Context 'Import module' {
    It "Module ($Module_Name) can be imported" {
        $Module_FilePath | Should -Exist

        { Import-Module $Module_FilePath -Force } | Should Not Throw
    }
} #>
