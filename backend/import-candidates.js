const { PrismaClient } = require('@prisma/client');
const fs = require('fs');
const path = require('path');

const prisma = new PrismaClient();

async function importCandidates() {
  console.log('🚀 Starting candidate import...\n');

  try {
    // Read the CSV file
    const csvPath = path.join(__dirname, 'data', 'Election-canadidates--Translated-english - Election-canadidates--Translated-english.csv');
    const csvData = fs.readFileSync(csvPath, 'utf-8');
    const lines = csvData.split('\n').slice(1); // Skip header

    console.log(`📄 Found ${lines.length} lines in CSV\n`);

    let imported = 0;
    let skipped = 0;

    for (const line of lines) {
      if (!line.trim()) continue;

      const parts = line.split(',');
      if (parts.length < 10) continue;

      try {
        const ballotNumber = parts[0]?.trim() || '';
        const partyName = parts[1]?.trim() || '';
        const sequence = parseInt(parts[2]?.trim()) || 0;
        const nominationType = parts[4]?.trim() || 'Unknown';
        const governorate = parts[5]?.trim() || 'Unknown';
        const sex = parts[7]?.trim()?.toUpperCase() || 'MALE';
        const fullName = parts[8]?.trim() || 'Unknown';
        const voterNumber = parseInt(parts[9]?.trim()) || 0;

        // Skip if essential data is missing
        if (!ballotNumber || !fullName || !voterNumber) {
          skipped++;
          continue;
        }

        // Create unique ID
        const uniqueId = `${governorate.substring(0, 3).toUpperCase()}-${ballotNumber}-${voterNumber}`.replace(/\s+/g, '-');

        // Generate referral code
        const referralCode = `${governorate.substring(0, 2).toUpperCase()}${voterNumber}${Date.now().toString().slice(-4)}`;

        await prisma.candidate.upsert({
          where: { uniqueCandidateId: uniqueId },
          update: {},
          create: {
            uniqueCandidateId: uniqueId,
            voterNumber: voterNumber,
            ballotNumber: ballotNumber,
            partyNameArabic: partyName,
            partyNameEnglish: partyName,
            candidateSequence: sequence,
            nominationType: nominationType,
            governorate: governorate,
            sex: sex === 'FEMALE' ? 'FEMALE' : 'MALE',
            fullNameArabic: fullName,
            fullNameEnglish: fullName,
            referralCode: referralCode,
            profileCompletionPercent: 30,
            viewsCount: 0,
            supportersCount: 0,
            postsCount: 0,
            eventsCount: 0,
            verificationStatus: 'unverified'
          }
        });

        imported++;
        if (imported % 50 === 0) {
          console.log(`✅ Imported ${imported} candidates...`);
        }
      } catch (err) {
        skipped++;
      }
    }

    console.log('\n✅ Import complete!');
    console.log(`   Imported: ${imported} candidates`);
    console.log(`   Skipped: ${skipped} invalid entries`);

    // Show stats
    const total = await prisma.candidate.count();
    const byGov = await prisma.candidate.groupBy({
      by: ['governorate'],
      _count: true
    });

    console.log(`\n📊 Database Stats:`);
    console.log(`   Total Candidates: ${total}`);
    console.log(`\n   By Governorate:`);
    byGov.forEach(g => {
      console.log(`   - ${g.governorate}: ${g._count} candidates`);
    });

  } catch (error) {
    console.error('❌ Import failed:', error.message);
  } finally {
    await prisma.$disconnect();
  }
}

importCandidates();
