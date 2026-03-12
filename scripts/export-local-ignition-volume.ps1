param(
    [string]$VolumeName = "ignition_data",
    [string]$DestinationRoot = (Join-Path $PSScriptRoot "..\ignition-src")
)

$folders = @("projects", "gateways", "user-lib", "modules")

if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    throw "Docker CLI was not found in PATH."
}

$resolvedDestination = (Resolve-Path $DestinationRoot).Path

foreach ($folder in $folders) {
    $targetPath = Join-Path $resolvedDestination $folder
    if (-not (Test-Path $targetPath)) {
        New-Item -ItemType Directory -Path $targetPath -Force | Out-Null
    }

    Get-ChildItem -Path $targetPath -Force | Remove-Item -Recurse -Force
}

$folderList = $folders -join ' '
$destinationMount = ($resolvedDestination -replace '\\', '/')

$command = @(
    'run', '--rm',
    '-v', "${VolumeName}:/data:ro",
    '-v', "${destinationMount}:/repo",
    'alpine:3.20',
    'sh', '-lc',
    "set -e; for folder in $folderList; do mkdir -p /repo/`$folder; if [ -d /data/`$folder ]; then cp -a /data/`$folder/. /repo/`$folder/; fi; done"
)

& docker @command
if ($LASTEXITCODE -ne 0) {
    throw "Export from Docker volume '$VolumeName' failed."
}

Write-Host "Ignition folders exported to $resolvedDestination"
