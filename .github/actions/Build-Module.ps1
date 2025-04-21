<# 
This script combines all public functions from the `src/functions/public`
directory into a single module file (`GUIDv7.psm1`) and updates the module manifest (`GUIDv7.psd1`) 
to include these functions for export.
#>

$AllPublicFunctions = Get-ChildItem "./src/functions/public" -Filter "*.ps1"
$ModuleName = "GUIDv7"
$ModulePath = "./src/$ModuleName.psm1"
$ModuleManifestPath = "./src/$ModuleName.psd1"

$FunctionsToExport = New-Object "System.Collections.Generic.List[Object]"


# copy all functions to the module file (.psm1)
foreach($PublicFunction in $AllPublicFunctions) {
    Add-Content -Path $ModulePath -Value (Get-Content -Path $PublicFunction.FullName) -Force
    $FunctionsToExport.Add($PublicFunction.BaseName)
}

# add functions to the module manifest
$ModuleManifest = Get-Content -Path $ModuleManifestPath
$RebuildModuleManifest = foreach($Line in $ModuleManifest) {
    if($Line -match "FunctionsToExport") {
        "FunctionsToExport = @('$($FunctionsToExport -join "','")')"
    } else {
        $Line
    }
}
$RebuildModuleManifest | Set-Content -Path $ModuleManifestPath -Force