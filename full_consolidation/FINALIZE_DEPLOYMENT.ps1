# ============================================
# HAMLET UNIFIED - FINAL DEPLOYMENT SCRIPT
# ============================================

Write-Host "`n🚀 FINALIZING DEPLOYMENT..." -ForegroundColor Cyan

# Backend URL (your Render service)
$BACKEND_URL = "https://srv-d3ra4p24d50c73bksgdg.onrender.com"

# ============================================
# 1. DEPLOY BACKEND TO GITHUB + RENDER
# ============================================

Write-Host "`n📦 Step 1: Deploying Backend..." -ForegroundColor Yellow

cd "E:\HamletUnified\full_consolidation"

# Initialize git if needed
if (-not (Test-Path ".git")) {
    git init
}

# Add backend remote (hamlet-complete-mvp)
git remote remove origin 2>$null
git remote add origin https://github.com/absulysuly/hamlet-complete-mvp.git

# Commit and push backend
git add backend/ render.yaml .gitignore
git commit -m "Deploy: Backend to Render" --allow-empty
git branch -M main
git push -u origin main --force

Write-Host "✅ Backend pushed to GitHub" -ForegroundColor Green

# ============================================
# 2. CREATE FRONTEND ENV FILES
# ============================================

Write-Host "`n🔧 Step 2: Creating Frontend Environment Files..." -ForegroundColor Yellow

cd "E:\HamletUnified\full_consolidation\frontend-aigoodstudeio"

# Create .env.local
@"
NEXT_PUBLIC_API_BASE_URL=$BACKEND_URL
GEMINI_MODE=stub
"@ | Out-File .env.local -Encoding UTF8

# Create .env.production
@"
NEXT_PUBLIC_API_BASE_URL=$BACKEND_URL
"@ | Out-File .env.production -Encoding UTF8

Write-Host "✅ Environment files created" -ForegroundColor Green

# ============================================
# 3. DEPLOY FRONTEND TO GITHUB
# ============================================

Write-Host "`n📦 Step 3: Deploying Frontend to GitHub..." -ForegroundColor Yellow

# Initialize git if needed
if (-not (Test-Path ".git")) {
    git init
}

# Add frontend remote (amlet-unified)
git remote remove origin 2>$null
git remote add origin https://github.com/absulysuly/amlet-unified.git

# Commit and push frontend (excluding .env.local but including .env.production)
git add .
git commit -m "Deploy: Frontend with backend connection" --allow-empty
git branch -M main
git push -u origin main --force

Write-Host "✅ Frontend pushed to GitHub" -ForegroundColor Green

# ============================================
# 4. DEPLOY TO VERCEL
# ============================================

Write-Host "`n🌐 Step 4: Deploying to Vercel..." -ForegroundColor Yellow

# Check if vercel CLI exists
if (Get-Command vercel -ErrorAction SilentlyContinue) {
    vercel --prod --yes
    Write-Host "✅ Frontend deployed to Vercel" -ForegroundColor Green
} else {
    Write-Host "⚠️  Vercel CLI not found. Install with: npm i -g vercel" -ForegroundColor Yellow
    Write-Host "   Then run: vercel --prod --yes" -ForegroundColor Yellow
}

# ============================================
# 5. VERIFICATION
# ============================================

Write-Host "`n✅ DEPLOYMENT COMPLETE!" -ForegroundColor Green
Write-Host "`n📊 VERIFICATION LINKS:" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray

Write-Host "`n🔹 Backend Health Check:" -ForegroundColor White
Write-Host "   $BACKEND_URL/health" -ForegroundColor Blue

Write-Host "`n🔹 Backend API Endpoints:" -ForegroundColor White
Write-Host "   $BACKEND_URL/api/candidates" -ForegroundColor Blue
Write-Host "   $BACKEND_URL/api/governorates" -ForegroundColor Blue
Write-Host "   $BACKEND_URL/api/stats" -ForegroundColor Blue

Write-Host "`n🔹 Render Dashboard:" -ForegroundColor White
Write-Host "   https://dashboard.render.com/web/srv-d3ra4p24d50c73bksgdg" -ForegroundColor Blue

Write-Host "`n🔹 GitHub Repositories:" -ForegroundColor White
Write-Host "   Backend:  https://github.com/absulysuly/hamlet-complete-mvp" -ForegroundColor Blue
Write-Host "   Frontend: https://github.com/absulysuly/amlet-unified" -ForegroundColor Blue

Write-Host "`n🔹 Vercel Dashboard:" -ForegroundColor White
Write-Host "   https://vercel.com/absulysulys-projects/test-new-frontend" -ForegroundColor Blue

Write-Host "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray

# Test backend
Write-Host "`n🧪 Testing Backend..." -ForegroundColor Cyan
try {
    $response = Invoke-RestMethod -Uri "$BACKEND_URL/health" -Method Get
    if ($response.status -eq "ok") {
        Write-Host "✅ Backend is LIVE and responding!" -ForegroundColor Green
    }
} catch {
    Write-Host "⚠️  Backend not responding yet (may take 1-2 min for Render to wake up)" -ForegroundColor Yellow
}

Write-Host "`n🎉 ALL DONE! Your app is deployed and live." -ForegroundColor Green
Write-Host "`n💡 Next: Check Vercel deployment URL and verify frontend connects to backend." -ForegroundColor Cyan

