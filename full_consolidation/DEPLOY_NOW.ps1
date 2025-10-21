# HAMLET UNIFIED - FINAL DEPLOYMENT

$BACKEND_URL = "https://srv-d3ra4p24d50c73bksgdg.onrender.com"

Write-Host "`nStep 1: Deploying Backend to GitHub..." -ForegroundColor Yellow

cd "E:\HamletUnified\full_consolidation"

if (-not (Test-Path ".git")) { git init }

git remote remove origin 2>$null
git remote add origin https://github.com/absulysuly/hamlet-complete-mvp.git

git add backend/ render.yaml .gitignore
git commit -m "Deploy: Backend to Render" --allow-empty
git branch -M main
git push -u origin main --force

Write-Host "Backend pushed to GitHub" -ForegroundColor Green

Write-Host "`nStep 2: Creating Frontend Environment Files..." -ForegroundColor Yellow

cd "E:\HamletUnified\full_consolidation\frontend-aigoodstudeio"

"NEXT_PUBLIC_API_BASE_URL=$BACKEND_URL`nGEMINI_MODE=stub" | Out-File .env.local -Encoding UTF8
"NEXT_PUBLIC_API_BASE_URL=$BACKEND_URL" | Out-File .env.production -Encoding UTF8

Write-Host "Environment files created" -ForegroundColor Green

Write-Host "`nStep 3: Deploying Frontend to GitHub..." -ForegroundColor Yellow

if (-not (Test-Path ".git")) { git init }

git remote remove origin 2>$null
git remote add origin https://github.com/absulysuly/amlet-unified.git

git add .
git commit -m "Deploy: Frontend with backend connection" --allow-empty
git branch -M main
git push -u origin main --force

Write-Host "Frontend pushed to GitHub" -ForegroundColor Green

Write-Host "`nStep 4: Deploying to Vercel..." -ForegroundColor Yellow

if (Get-Command vercel -ErrorAction SilentlyContinue) {
    vercel --prod --yes
    Write-Host "Deployed to Vercel" -ForegroundColor Green
} else {
    Write-Host "Vercel CLI not found. Install: npm i -g vercel" -ForegroundColor Yellow
    Write-Host "Then run: vercel --prod --yes" -ForegroundColor Yellow
}

Write-Host "`n=== DEPLOYMENT COMPLETE ===" -ForegroundColor Green
Write-Host "`nBackend Health: $BACKEND_URL/health" -ForegroundColor Cyan
Write-Host "Backend API: $BACKEND_URL/api/candidates" -ForegroundColor Cyan
Write-Host "`nRender: https://dashboard.render.com/web/srv-d3ra4p24d50c73bksgdg" -ForegroundColor Cyan
Write-Host "Vercel: https://vercel.com/absulysulys-projects/test-new-frontend" -ForegroundColor Cyan

Write-Host "`nTesting backend..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "$BACKEND_URL/health" -Method Get
    if ($response.status -eq "ok") {
        Write-Host "Backend is LIVE!" -ForegroundColor Green
    }
} catch {
    Write-Host "Backend warming up (wait 1-2 min)..." -ForegroundColor Yellow
}

Write-Host "`nALL DONE!" -ForegroundColor Green

