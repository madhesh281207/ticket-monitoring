# Run from this repository with: .\scripts\start-chennai-monitor.ps1
$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot\..

$nodeCommand = Get-Command node -ErrorAction SilentlyContinue
if (-not $nodeCommand) {
    throw "Node.js 22 or newer is required. Install it from https://nodejs.org/ and reopen PowerShell."
}

$nodeVersionText = (& node --version).Trim().TrimStart([char]"v")
$nodeVersion = [version]$nodeVersionText
if ($nodeVersion.Major -lt 22) {
    throw "Node.js 22 or newer is required. Detected $nodeVersionText."
}

if (-not (Test-Path ".env")) {
    if (-not (Test-Path ".env.chennai.example")) {
        throw "Missing .env.chennai.example. Run this script from a complete copy of the ticket-monitoring repository."
    }

    $bytes = New-Object byte[] 24
    $rng = [System.Security.Cryptography.RandomNumberGenerator]::Create()
    try { $rng.GetBytes($bytes) } finally { $rng.Dispose() }
    $topic = "doomsday-" + [BitConverter]::ToString($bytes).Replace("-", "").ToLowerInvariant()

    $envText = [System.IO.File]::ReadAllText((Join-Path $PWD ".env.chennai.example"))
    $envText = $envText.Replace("REPLACE_WITH_A_LONG_RANDOM_NTFY_TOPIC", $topic)
    $utf8NoBom = New-Object System.Text.UTF8Encoding -ArgumentList $false
    [System.IO.File]::WriteAllText((Join-Path $PWD ".env"), $envText, $utf8NoBom)

    Write-Host ""
    Write-Host "Your private ntfy topic (subscribe to this exact topic in the ntfy phone app):" -ForegroundColor Yellow
    Write-Host $topic -ForegroundColor Cyan
    Write-Host "Keep this topic private. It is saved only in your local .env file, which is git-ignored."
} else {
    Write-Host "Existing .env found; leaving it unchanged."
    $topicLine = Select-String -Path ".env" -Pattern "^NTFY_TOPIC=(.+)$" | Select-Object -First 1
    if ($topicLine) {
        $topic = $topicLine.Matches[0].Groups[1].Value.Trim()
        Write-Host "Your configured ntfy topic (subscribe to this exact topic in the ntfy phone app):" -ForegroundColor Yellow
        Write-Host $topic -ForegroundColor Cyan
    }
}

Read-Host "Install/open ntfy on your phone and subscribe to the topic above, then press Enter to continue"

Write-Host ""
Write-Host "Installing project dependencies..."
& npm ci
if ($LASTEXITCODE -ne 0) { throw "npm ci failed. Fix the reported error and run this script again." }

Write-Host ""
Write-Host "Running one availability check..."
& npm run check
if ($LASTEXITCODE -ne 0) {
    throw "The initial check failed. Read the error above; an HTTP 403/provider error is not proof that bookings are closed."
}

Write-Host ""
Write-Host "Starting the five-minute monitor. Keep this window open; press Ctrl+C to stop."
& npm start
