param(
    [Parameter(Mandatory=$false)]
    [string]$MAIN_FILENAME = "MAIN.S",

    [Parameter(Mandatory=$false)]
    [bool]$STAGE_FLAG = $true
)

$ErrorActionPreference = "Stop"

# Prompt the user with a question
$response = Read-Host "Have you generate a new MAIN.S using CUBE Voyager after making changes to the codebase? (Yes/No)"

# Check the user's response
if ($response -eq "Yes" -or $response -ilike "Y*") {
    Write-Host "Continuing with the rest of the script..."    
} elseif ($response -eq "No" -or $response -ilike "N*") {
    Write-Host "Please see these instructions before committing the MAIN.S script here: https://publictransportvic.atlassian.net/l/cp/RpffXtwF."
    Exit
} else {
    Write-Host "Invalid response. Please enter 'Yes' or 'No'."
}

# remove comments from MAIN.S ---------------------------------------------
Write-Host "> Remove lines starting with ';' from $inputFilePath"

# Specify the path to the input text file
$inputFilePath = "Applications\$MAIN_FILENAME"

# Specify the path to the output text file
$outputFilePath = "Applications\$MAIN_FILENAME"

# Read the content of the input file
$fileContent = Get-Content -Path $inputFilePath

# Filter out lines that start with a semicolon
$filteredContent = $fileContent | Where-Object { $_ -notmatch "^\s*;" }

# Write the filtered content to the output file
$filteredContent | Set-Content -Path $outputFilePath

Write-Host "--> Done!"

if ($STAGE_FLAG -eq $true) {
  git add Applications\$MAIN_FILENAME
  Write-Host "Added Applications\$MAIN_FILENAME to staging"
}
