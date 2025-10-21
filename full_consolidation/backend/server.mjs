
import express from 'express';
import cors from 'cors';

const app = express();

// Configure CORS - allow Vercel and any other specified origins
const allowedOrigins = [
  'https://amlet-unified.vercel.app',
  'https://test-new-frontend.vercel.app',
  'https://amlet-unified-absulysulys-projects.vercel.app',
  'http://localhost:3000',
  'http://localhost:3001'
];

// Add custom CORS_ORIGIN if provided
if (process.env.CORS_ORIGIN) {
  const customOrigins = process.env.CORS_ORIGIN.split(',').map(o => o.trim());
  allowedOrigins.push(...customOrigins);
}

app.use(cors({ 
  origin: (origin, callback) => {
    // Allow requests with no origin (mobile apps, Postman, etc.)
    if (!origin) return callback(null, true);
    
    if (allowedOrigins.includes(origin)) {
      callback(null, true);
    } else {
      console.log(`CORS blocked origin: ${origin}`);
      callback(null, true); // Allow all for now, restrict later
    }
  },
  credentials: true
}));

app.use(express.json());

const PORT = Number(process.env.PORT || 4001);

const GOVERNORATES = [
  'Baghdad',
  'Basra',
  'Nineveh',
  'Erbil',
  'Sulaymaniyah',
  'Dohuk',
  'Anbar',
  'Diyala',
  'Kirkuk',
  'Salah al-Din',
  'Wasit',
  'Maysan',
  'Babil',
  'Najaf',
  'Karbala',
  'Qadisiyyah',
  'Dhi Qar',
  'Muthanna'
];

const PARTIES = ['Independent', 'KDP', 'PUK', 'State of Law', 'Sadrist', 'Conquest'];
const NAMES = ['Ahmed Al-Maliki', 'Ali Al-Sadr', 'Hassan Al-Hakim', 'Fatima Al-Kurdi'];

const candidates = Array.from({ length: 200 }, (_, i) => ({
  id: String(i + 1),
  name: `${NAMES[i % NAMES.length]} ${i + 1}`,
  governorate: GOVERNORATES[i % GOVERNORATES.length],
  party: PARTIES[i % PARTIES.length],
  ballot_number: (i % 90) + 1,
  gender: i % 3 === 0 ? 'Female' : 'Male'
}));

app.get('/health', (req, res) => {
  res.json({ status: 'ok' });
});

app.get('/api/candidates', (req, res) => {
  const page = Math.max(parseInt(req.query.page) || 1, 1);
  const limit = Math.max(parseInt(req.query.limit) || 20, 1);

  let filtered = candidates;
  const { governorate, gender, party } = req.query;
  if (governorate) filtered = filtered.filter(c => c.governorate === governorate);
  if (gender) filtered = filtered.filter(c => c.gender === gender);
  if (party) filtered = filtered.filter(c => c.party === party);

  const start = (page - 1) * limit;
  const end = start + limit;

  res.json({
    data: filtered.slice(start, end),
    total: filtered.length,
    page,
    limit
  });
});

app.get('/api/candidates/:id', (req, res) => {
  const c = candidates.find(c => c.id === req.params.id);
  if (!c) return res.status(404).json({ error: 'Not found' });
  res.json(c);
});

app.get('/api/governorates', (req, res) => {
  // Return array of strings for simplicity
  res.json(GOVERNORATES);
});

app.get('/api/stats', (req, res) => {
  const total = candidates.length;
  const male = candidates.filter(c => c.gender === 'Male').length;
  const female = candidates.filter(c => c.gender === 'Female').length;
  const byGov = GOVERNORATES.map(g => ({
    governorate: g,
    count: candidates.filter(c => c.governorate === g).length
  }));

  res.json({
    total_candidates: total,
    gender_distribution: { Male: male, Female: female },
    candidates_per_governorate: byGov
  });
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Backend listening on port ${PORT}`);
});

export default app;
