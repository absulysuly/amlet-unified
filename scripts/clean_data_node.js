const fs = require('fs');

console.log(' Reading existing JSON file...');
const rawData = fs.readFileSync('E:/HamletUnified/data/candidates_production_ready.json', 'utf-8');
const candidates = JSON.parse(rawData);

console.log(` Cleaning ${candidates.length} candidates...`);

const cleaned = candidates.map((c, idx) => {
  let ballotNum = String(c.ballotNumber || '').replace(/dtype.*$/g, '').replace(/\n/g, ' ').trim();
  ballotNum = ballotNum.match(/\d+/)?.[0] || '';
  
  let partyArabic = String(c.partyNameArabic || '').replace(/ballotNumber.*\n/g, '').replace(/dtype.*$/g, '').trim();
  
  let gov = String(c.governorate || '').trim();
  const govMap = {
    'The egg': 'Dhi Qar',
    'Babylon': 'Babil',
    'Baghdad': 'Baghdad'
  };
  gov = govMap[gov] || gov;
  
  let nameArabic = String(c.fullNameArabic || '').replace(/\s+/g, ' ').replace(/\n/g, ' ').replace(/-\s+/g, '').trim();
  
  const govCode = gov.substring(0, 3).toUpperCase() || 'UNK';
  const voterNum = c.voterNumber || idx;
  const uniqueId = `${govCode}-${ballotNum}-${String(voterNum).padStart(6, '0')}`;
  
  return {
    uniqueCandidateId: uniqueId,
    voterNumber: c.voterNumber || null,
    ballotNumber: ballotNum,
    partyNameArabic: partyArabic,
    partyNameEnglish: c.partyNameEnglish || null,
    candidateSequence: c.candidateSequence || null,
    nominationType: c.nominationType || '',
    governorate: gov,
    sex: (c.sex || 'MALE').toUpperCase(),
    fullNameArabic: nameArabic,
    fullNameEnglish: c.fullNameEnglish || null,
    email: null,
    phone: null,
    bio: null,
    photoUrl: null,
    coverPhotoUrl: null,
    verificationStatus: 'unverified',
    profileCompletionPercent: 30,
    viewsCount: 0,
    supportersCount: 0,
    postsCount: 0,
    eventsCount: 0,
    referralCode: uniqueId,
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString()
  };
});

console.log(` Saving ${cleaned.length} cleaned candidates...`);
fs.writeFileSync('E:/HamletUnified/data/candidates_cleaned_final.json', JSON.stringify(cleaned, null, 2), 'utf-8');

console.log(` Successfully cleaned ${cleaned.length} candidates!`);
console.log(' Saved to: E:/HamletUnified/data/candidates_cleaned_final.json');