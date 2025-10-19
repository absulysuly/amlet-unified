# Data Collection Startup Script for Windows
# Place this in your Windows startup folder or run manually

Write-Host "🚀 Starting Iraq Compass Data Collection..." -ForegroundColor Green

# Change to project directory
Set-Location "E:\missinggold-fresh"

# Check if PM2 is installed
try {
    $pm2Version = pm2 --version 2>$null
    if ($pm2Version) {
        Write-Host "✅ PM2 found (version: $pm2Version)" -ForegroundColor Green
    } else {
        Write-Host "❌ PM2 not found. Installing..." -ForegroundColor Yellow
        npm install -g pm2
    }
} catch {
    Write-Host "❌ PM2 not accessible. Please install PM2 globally." -ForegroundColor Red
    exit 1
}

# Check if ecosystem file exists
if (Test-Path "ecosystem.config.js") {
    Write-Host "✅ Ecosystem config found" -ForegroundColor Green
} else {
    Write-Host "❌ Ecosystem config not found" -ForegroundColor Red
    exit 1
}

# Check if logs directory exists
if (!(Test-Path "logs")) {
    New-Item -ItemType Directory -Path "logs" | Out-Null
    Write-Host "📁 Created logs directory" -ForegroundColor Yellow
}

# Start data collection
Write-Host "🔄 Starting data collection process..." -ForegroundColor Cyan
try {
    pm2 start ecosystem.config.js
    Write-Host "✅ Data collection started successfully" -ForegroundColor Green

    # Save PM2 configuration
    pm2 save
    Write-Host "💾 PM2 configuration saved" -ForegroundColor Green

    # Show status
    Write-Host "`n📊 Current Status:" -ForegroundColor Cyan
    pm2 status

    Write-Host "`n🎯 Data collection is now running continuously!" -ForegroundColor Green
    Write-Host "💡 Monitor with: pm2 logs iraqi-compass-data-collector" -ForegroundColor Yellow
    Write-Host "💡 Check status with: pm2 status" -ForegroundColor Yellow

} catch {
    Write-Host "❌ Failed to start data collection: $($_.Exception.Message)" -ForegroundColor Red

    Write-Host "`n🔧 Manual start instructions:" -ForegroundColor Yellow
    Write-Host "1. cd E:\missinggold-fresh" -ForegroundColor Gray
    Write-Host "2. pm2 start ecosystem.config.js" -ForegroundColor Gray
    Write-Host "3. pm2 save" -ForegroundColor Gray
}
