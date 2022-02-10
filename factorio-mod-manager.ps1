[Cmdletbinding()]
param (
    [Parameter(Mandatory)]
    [string]
    [ValidateNotNullOrEmpty()]
    $Mod
)
$ErrorActionPreference = 'Stop'

$modTarget = "mods"
$saveTarget = "saves"
$scenarioTarget = "scenarios"

$modpacksFolder = Join-Path $PSScriptRoot "modpacks"
$factorioFolder = Get-Item (Join-Path $env:APPDATA Factorio)
$targets = $modTarget, $saveTarget, $scenarioTarget

New-Item -ItemType Directory -Path $modpacksFolder -Force -ErrorAction SilentlyContinue | Out-Null

foreach ($target in $targets) {
    $targetPath = Join-Path $factorioFolder $target
    $sourcePath = [IO.Path]::Combine($modpacksFolder, $Mod, $target)

    New-item -ItemType Directory -Path $sourcePath -Force -ErrorAction SilentlyContinue | Out-Null

    if (Test-Path $targetPath) {
        $junction = Get-Item $targetPath
        if ($junction.LinkType -eq "Junction") {
            [IO.Directory]::Delete($junction)
        }
        else {
            if ((Test-Path "$sourcePath\*") -and (Test-Path "$targetPath\*")) {
                throw "Target: {0} exists as a real directory with contents and so does source: {1}. This means we can't move the contents inside 'target' to new 'source' directory and make a junction to it. Check the 'source' directory is empty." -f $targetPath, $sourcePath
            }
            
            foreach ($file in [IO.Directory]::GetFiles($targetPath)) {
                $dest = [IO.Path]::Join($sourcePath, [IO.Path]::GetFileName($file))
                [IO.File]::Copy($file, $dest)
                [IO.File]::Delete($file)
            }

            [IO.Directory]::Delete($targetPath)
        }
    }

    New-Item -ItemType Junction -Path $targetPath -Value $sourcePath | Out-Null
}
