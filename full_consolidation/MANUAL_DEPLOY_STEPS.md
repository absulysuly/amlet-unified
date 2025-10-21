# FINAL DEPLOYMENT STEPS

## ✅ COMPLETED
- [x] Backend code pushed to GitHub: https://github.com/absulysuly/hamlet-complete-mvp
- [x] Frontend code pushed to GitHub: https://github.com/absulysuly/amlet-unified
- [x] Environment files created

## 🔧 MANUAL STEPS NEEDED

### 1. RENDER - Deploy Backend

**Go to:** https://dashboard.render.com/web/srv-d3ra4p24d50c73bksgdg

**Click these buttons:**
1. Click "Manual Deploy" (top right)
2. Select "Clear build cache & deploy"

**Verify Settings (Settings tab):**
- **Root Directory:** `backend`
- **Build Command:** `npm install`
- **Start Command:** `node server.mjs`

Wait 2-3 minutes for deployment to complete.

**Test Backend:**
- Health: https://srv-d3ra4p24d50c73bksgdg.onrender.com/health
- API: https://srv-d3ra4p24d50c73bksgdg.onrender.com/api/candidates

---

### 2. VERCEL - Deploy Frontend

**Option A: Auto-Deploy (Recommended)**

Vercel is already connected to your GitHub. It should auto-deploy when you push.

**Go to:** https://vercel.com/absulysulys-projects/test-new-frontend

Check if a new deployment started. If not:

**Option B: Import from GitHub**

1. Go to: https://vercel.com/new
2. Select repository: `absulysuly/amlet-unified`
3. Framework: **Next.js**
4. Root Directory: `frontend-aigoodstudeio`
5. Environment Variables:
   - `NEXT_PUBLIC_API_BASE_URL` = `https://srv-d3ra4p24d50c73bksgdg.onrender.com`
6. Click "Deploy"

---

### 3. VERIFY DEPLOYMENT

Once both are deployed:

**Backend Check:**
```
https://srv-d3ra4p24d50c73bksgdg.onrender.com/health
```
Should return: `{"status":"ok"}`

**Frontend Check:**
Open your Vercel deployment URL and verify:
- Page loads
- Can browse candidates
- Filters work
- No console errors

---

## 📊 YOUR DEPLOYMENT LINKS

- **Backend GitHub:** https://github.com/absulysuly/hamlet-complete-mvp
- **Frontend GitHub:** https://github.com/absulysuly/amlet-unified
- **Render Dashboard:** https://dashboard.render.com/web/srv-d3ra4p24d50c73bksgdg
- **Vercel Dashboard:** https://vercel.com/absulysulys-projects/test-new-frontend

---

## ⚠️ DISK SPACE WARNING

Your disk is full! Before continuing:

1. **Clear browser cache**
2. **Empty Recycle Bin**
3. **Delete temporary files:** Run in PowerShell:
   ```powershell
   Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
   ```
4. **Clean npm cache:**
   ```powershell
   npm cache clean --force
   ```

---

## 🎯 CURRENT STATUS

- ✅ Code ready and pushed to GitHub
- ⏳ Waiting for Render deployment
- ⏳ Waiting for Vercel auto-deploy
- ❌ Disk full - clean up space

**Next Action:** Go to Render dashboard and click "Manual Deploy"

