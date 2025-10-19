# clean-and-reset.ps1 - Comprehensive project reset script

# Stop all running Node processes
try {
    Write-Host "🛑 Stopping all Node processes..." -ForegroundColor Yellow
    Stop-Process -Name node -Force -ErrorAction SilentlyContinue
} catch {
    Write-Host "No Node processes to stop." -ForegroundColor Gray
}

# Clear npm cache
Write-Host "🧹 Cleaning npm cache..." -ForegroundColor Yellow
npm cache clean --force

# Remove node_modules and lock files
$itemsToRemove = @(
    "node_modules",
    "package-lock.json",
    "yarn.lock",
    "pnpm-lock.yaml",
    ".svelte-kit",
    ".vite",
    ".vercel",
    ".netlify",
    "dist",
    "build",
    ".next"
)

foreach ($item in $itemsToRemove) {
    if (Test-Path $item) {
        Write-Host "🗑️  Removing $item..." -ForegroundColor Yellow
        Remove-Item -Recurse -Force $item -ErrorAction SilentlyContinue
    }
}

# Reinstall dependencies
Write-Host "📦 Reinstalling dependencies..." -ForegroundColor Yellow
npm install

Write-Host "✅ Project reset complete! Run 'npm run dev' to start the development server." -ForegroundColor Green
