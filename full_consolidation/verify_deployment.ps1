# DEPLOYMENT VERIFICATION SCRIPT

$BACKEND = "https://srv-d3ra4p24d50c73bksgdg.onrender.com"

Write-Host "`n=== VERIFYING DEPLOYMENT ===" -ForegroundColor Cyan

# Test 1: Backend Health
Write-Host "`nTest 1: Backend Health Check..." -ForegroundColor Yellow
try {
    $health = Invoke-RestMethod -Uri "$BACKEND/health" -Method Get
    if ($health.status -eq "ok") {
        Write-Host "✓ Backend Health: PASSED" -ForegroundColor Green
    } else {
        Write-Host "✗ Backend Health: FAILED" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Backend Health: NOT RESPONDING" -ForegroundColor Red
    Write-Host "  Error: $_" -ForegroundColor Gray
}

# Test 2: Candidates API
Write-Host "`nTest 2: Candidates API..." -ForegroundColor Yellow
try {
    $candidates = Invoke-RestMethod -Uri "$BACKEND/api/candidates?limit=5" -Method Get
    if ($candidates.data.Count -gt 0) {
        Write-Host "✓ Candidates API: PASSED ($($candidates.total) candidates)" -ForegroundColor Green
    } else {
        Write-Host "✗ Candidates API: No data returned" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Candidates API: FAILED" -ForegroundColor Red
    Write-Host "  Error: $_" -ForegroundColor Gray
}

# Test 3: Governorates API
Write-Host "`nTest 3: Governorates API..." -ForegroundColor Yellow
try {
    $govs = Invoke-RestMethod -Uri "$BACKEND/api/governorates" -Method Get
    if ($govs.Count -gt 0) {
        Write-Host "✓ Governorates API: PASSED ($($govs.Count) governorates)" -ForegroundColor Green
    } else {
        Write-Host "✗ Governorates API: No data" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Governorates API: FAILED" -ForegroundColor Red
    Write-Host "  Error: $_" -ForegroundColor Gray
}

# Test 4: Stats API
Write-Host "`nTest 4: Stats API..." -ForegroundColor Yellow
try {
    $stats = Invoke-RestMethod -Uri "$BACKEND/api/stats" -Method Get
    if ($stats.total_candidates -gt 0) {
        Write-Host "✓ Stats API: PASSED ($($stats.total_candidates) total candidates)" -ForegroundColor Green
    } else {
        Write-Host "✗ Stats API: No data" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Stats API: FAILED" -ForegroundColor Red
    Write-Host "  Error: $_" -ForegroundColor Gray
}

Write-Host "`n=== DEPLOYMENT STATUS ===" -ForegroundColor Cyan
Write-Host "Backend: $BACKEND" -ForegroundColor White
Write-Host "`nRender Dashboard:" -ForegroundColor White
Write-Host "https://dashboard.render.com/web/srv-d3ra4p24d50c73bksgdg" -ForegroundColor Blue
Write-Host "`nVercel Dashboard:" -ForegroundColor White  
Write-Host "https://vercel.com/absulysulys-projects/test-new-frontend" -ForegroundColor Blue
Write-Host "`n"

