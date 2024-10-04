$ErrorActionPreference = "Stop"

$data = Get-Content -Raw -Path "ps_settings.json" | ConvertFrom-Json

$filePath = $data.catalog_path
$pythonPath = $data.python_vitmtools
$scriptPath = $data.vitmtools_extract_and_replace_module
$vitmtoolsCondaEnvname = $data.vitmtools_conda_envname

$_VitmtoolsPython = conda env list | Select-String "^$vitmtoolsCondaEnvname"
$VitmtoolsPython = $_VitmtoolsPython -split '\s+' | Select-Object -Index 1

if (-not $VitmtoolsPython) {
    # Display message
    Write-Error "The 'vitmtools' Conda environment was not found. Please make sure to successfully run `ps_setup_vitmtools_condaenv.ps1` before using this powershell script."
    
    # Exit script or command
    return
}

$env:PYTHONPATH="vitmtools"; . $VitmtoolsPython\Python.exe $scriptPath $filePath "Catalog_info"

Write-Host "Parsed $filePath to CSV"

# Check if the Catalog.csv file has been modified
$catalogChange = git status --porcelain Catalog_info\Catalog.csv | Select-String -Pattern "^ M"

# If Catalog.csv has been modified, then add $filePath
if ($catalogChange) {
    Write-Host "Changes detected in the Catalog file"

    Write-Host "Staging `$filePath`"
    git add $filePath

    Write-Host "Staging `Catalog_info\Catalog.csv`"
    git add .\Catalog_info\Catalog.csv
} else {
    Write-Host "No changes detected in the Catalog file"
}
