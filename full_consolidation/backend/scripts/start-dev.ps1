# start-dev.ps1 - Safe development environment starter

# Check for Node.js
$nodeVersion = node --version
if (-not $nodeVersion) {
    Write-Host "❌ Node.js is not installed. Please install Node.js 18+ and try again." -ForegroundColor Red
    exit 1
}

# Check for npm
$npmVersion = npm --version
if (-not $npmVersion) {
    Write-Host "❌ npm is not installed. Please install npm and try again." -ForegroundColor Red
    exit 1
}

# Check for required global packages
$requiredPackages = @("vite")
foreach ($pkg in $requiredPackages) {
    $installed = npm list -g $pkg --depth=0 2>$null
    if (-not $installed) {
        Write-Host "📦 Installing required global package: $pkg" -ForegroundColor Yellow
        npm install -g $pkg
    }
}

# Check if node_modules exists
if (-not (Test-Path "node_modules")) {
    Write-Host "📦 Installing project dependencies..." -ForegroundColor Yellow
    npm install
}

# Start the development server
Write-Host "🚀 Starting development server..." -ForegroundColor Green
Write-Host "   - Local:    http://localhost:5173" -ForegroundColor Cyan
Write-Host "   - Network:  http://$((Test-Connection -ComputerName $env:COMPUTERNAME -Count 1).IPV4Address.IPAddressToString):5173" -ForegroundColor Cyan
Write-Host "   - Press Ctrl+C to stop" -ForegroundColor Gray

# Start Vite dev server
vite --host 0.0.0.0
