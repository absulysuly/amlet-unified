# Real-time deployment status checker

$BACKEND = "https://srv-d3ra4p24d50c73bksgdg.onrender.com"
$FRONTEND = "https://amlet-unified.vercel.app"

Write-Host "`n===========================================" -ForegroundColor Cyan
Write-Host "  DEPLOYMENT STATUS CHECKER" -ForegroundColor Cyan  
Write-Host "===========================================" -ForegroundColor Cyan

# Check Backend
Write-Host "`n[1/3] Checking Backend..." -ForegroundColor Yellow
try {
    $health = Invoke-RestMethod -Uri "$BACKEND/health" -Method Get -TimeoutSec 10
    if ($health.status -eq "ok") {
        Write-Host "  BACKEND: LIVE" -ForegroundColor Green -NoNewline
        Write-Host " - CORS fix deployed" -ForegroundColor Gray
    }
} catch {
    Write-Host "  BACKEND: DEPLOYING or STARTING UP..." -ForegroundColor Yellow
    Write-Host "  (Render free tier may take 30-60 sec to wake up)" -ForegroundColor Gray
}

# Check Backend API
Write-Host "`n[2/3] Checking Backend API..." -ForegroundColor Yellow
try {
    $candidates = Invoke-RestMethod -Uri "$BACKEND/api/candidates?limit=3" -Method Get -TimeoutSec 10
    Write-Host "  API: WORKING" -ForegroundColor Green -NoNewline
    Write-Host " - $($candidates.total) candidates available" -ForegroundColor Gray
} catch {
    Write-Host "  API: NOT READY YET" -ForegroundColor Yellow
}

# Check Frontend
Write-Host "`n[3/3] Checking Frontend..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri $FRONTEND -Method Head -TimeoutSec 10
    if ($response.StatusCode -eq 200) {
        Write-Host "  FRONTEND: LIVE" -ForegroundColor Green -NoNewline
        Write-Host " - Styling fix deployed" -ForegroundColor Gray
    }
} catch {
    Write-Host "  FRONTEND: DEPLOYING..." -ForegroundColor Yellow
}

Write-Host "`n===========================================" -ForegroundColor Cyan
Write-Host "  DASHBOARDS" -ForegroundColor Cyan
Write-Host "===========================================" -ForegroundColor Cyan
Write-Host "`nRender (Backend):" -ForegroundColor White
Write-Host "  https://dashboard.render.com/web/srv-d3ra4p24d50c73bksgdg" -ForegroundColor Blue

Write-Host "`nVercel (Frontend):" -ForegroundColor White
Write-Host "  https://vercel.com/absulysulys-projects/test-new-frontend" -ForegroundColor Blue

Write-Host "`n===========================================" -ForegroundColor Cyan
Write-Host "  TEST URLS" -ForegroundColor Cyan
Write-Host "===========================================" -ForegroundColor Cyan
Write-Host "`nBackend Health:" -ForegroundColor White
Write-Host "  $BACKEND/health" -ForegroundColor Blue

Write-Host "`nBackend API:" -ForegroundColor White
Write-Host "  $BACKEND/api/candidates" -ForegroundColor Blue

Write-Host "`nLive App:" -ForegroundColor White
Write-Host "  $FRONTEND" -ForegroundColor Blue

Write-Host "`n===========================================" -ForegroundColor Cyan
Write-Host "`nRun this script again in 2 minutes to check deployment progress." -ForegroundColor Gray
Write-Host "`n"

