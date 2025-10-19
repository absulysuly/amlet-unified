const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const compression = require('compression');
const morgan = require('morgan');
const rateLimit = require('express-rate-limit');
const { PrismaClient } = require('@prisma/client');
const winston = require('winston');
require('dotenv').config();

const app = express();
const prisma = new PrismaClient();
const PORT = process.env.PORT || 4001;

const logger = winston.createLogger({
  level: 'info',
  format: winston.format.simple(),
  transports: [new winston.transports.Console()]
});

app.use(helmet());
app.use(cors({ origin: '*', credentials: true }));
app.use(compression());
app.use(express.json());
app.use(morgan('combined'));

const limiter = rateLimit({ windowMs: 15 * 60 * 1000, max: 200 });
app.use('/api/', limiter);

const asyncHandler = fn => (req, res, next) => Promise.resolve(fn(req, res, next)).catch(next);

app.get('/', (req, res) => {
  res.json({
    status: 'online',
    service: 'Hamlet Election API',
    version: '1.0.0',
    database: 'Connected',
    user: 'absulysuly',
    endpoints: {
      candidates: '/api/candidates',
      search: '/api/candidates/search',
      governorates: '/api/governorates',
      parties: '/api/parties',
      stats: '/api/stats',
      trending: '/api/trending'
    }
  });
});

app.get('/api/candidates', asyncHandler(async (req, res) => {
  const page = Math.max(1, parseInt(req.query.page) || 1);
  const limit = Math.min(100, parseInt(req.query.limit) || 20);
  const skip = (page - 1) * limit;
  const { governorate, sex, nominationType } = req.query;
  
  const where = {};
  if (governorate) where.governorate = governorate;
  if (sex) where.sex = sex.toUpperCase();
  if (nominationType) where.nominationType = nominationType;

  const [candidates, total] = await Promise.all([
    prisma.candidate.findMany({ where, skip, take: limit, orderBy: { fullNameArabic: 'asc' } }),
    prisma.candidate.count({ where })
  ]);

  res.json({
    success: true,
    data: candidates,
    pagination: { page, limit, total, pages: Math.ceil(total / limit) }
  });
}));

app.get('/api/candidates/search', asyncHandler(async (req, res) => {
  const { q, governorate, sex, limit = 50 } = req.query;
  const where = {};
  
  if (q) {
    where.OR = [
      { fullNameArabic: { contains: q } },
      { fullNameEnglish: { contains: q } },
      { partyNameArabic: { contains: q } }
    ];
  }
  if (governorate) where.governorate = governorate;
  if (sex) where.sex = sex.toUpperCase();

  const candidates = await prisma.candidate.findMany({
    where,
    take: parseInt(limit),
    orderBy: { viewsCount: 'desc' }
  });

  res.json({ success: true, count: candidates.length, data: candidates });
}));

app.get('/api/candidates/:id', asyncHandler(async (req, res) => {
  const candidate = await prisma.candidate.findUnique({ where: { id: req.params.id } });
  if (!candidate) return res.status(404).json({ success: false, error: 'Not found' });
  
  prisma.candidate.update({
    where: { id: req.params.id },
    data: { viewsCount: { increment: 1 } }
  }).catch(() => {});

  res.json({ success: true, data: candidate });
}));

app.get('/api/governorates', asyncHandler(async (req, res) => {
  const result = await prisma.candidate.groupBy({
    by: ['governorate'],
    _count: true,
    orderBy: { governorate: 'asc' }
  });
  const governorates = result.map(g => ({ name: g.governorate, count: g._count })).filter(g => g.name);
  res.json({ success: true, count: governorates.length, data: governorates });
}));

app.get('/api/parties', asyncHandler(async (req, res) => {
  const result = await prisma.candidate.groupBy({
    by: ['partyNameArabic'],
    _count: true,
    orderBy: { _count: { partyNameArabic: 'desc' } }
  });
  const parties = result.map(p => ({ name: p.partyNameArabic, count: p._count })).filter(p => p.name).slice(0, 50);
  res.json({ success: true, count: parties.length, data: parties });
}));

app.get('/api/stats', asyncHandler(async (req, res) => {
  const [total, male, female, govStats] = await Promise.all([
    prisma.candidate.count(),
    prisma.candidate.count({ where: { sex: 'MALE' } }),
    prisma.candidate.count({ where: { sex: 'FEMALE' } }),
    prisma.candidate.groupBy({ by: ['governorate'], _count: true })
  ]);

  res.json({
    success: true,
    data: {
      total,
      byGender: { male, female },
      byGovernorate: govStats.map(g => ({ governorate: g.governorate, count: g._count }))
    }
  });
}));

app.get('/api/trending', asyncHandler(async (req, res) => {
  const trending = await prisma.candidate.findMany({
    take: 20,
    orderBy: [{ viewsCount: 'desc' }, { supportersCount: 'desc' }]
  });
  res.json({ success: true, data: trending });
}));

app.use((req, res) => res.status(404).json({ success: false, error: 'Not found' }));
app.use((err, req, res, next) => {
  logger.error(err.message);
  res.status(500).json({ success: false, error: 'Server error' });
});

app.listen(PORT, () => {
  console.log('\n' + '═'.repeat(60));
  console.log('🚀 HAMLET API - PRODUCTION READY');
  console.log('═'.repeat(60));
  console.log('📡 Server: http://localhost:' + PORT);
  console.log('🗄️ Database: hamlet_election');
  console.log('👤 User: absulysuly');
  console.log('✅ Ready!');
  console.log('═'.repeat(60) + '\n');
});

process.on('SIGINT', async () => { await prisma.$disconnect(); process.exit(0); });
