const { PrismaClient } = require('@prisma/client');
const fs = require('fs');

const prisma = new PrismaClient();

async function importCandidates() {
  console.log(' Reading cleaned data...');
  
  const candidates = JSON.parse(fs.readFileSync('E:/HamletUnified/data/candidates_cleaned_final.json', 'utf-8'));
  
  console.log(` Importing ${candidates.length} cleaned candidates...`);
  
  let imported = 0;
  let errors = 0;
  let skipped = 0;
  
  for (const candidate of candidates) {
    try {
      const existing = await prisma.candidate.findUnique({
        where: { uniqueCandidateId: candidate.uniqueCandidateId }
      });
      
      if (existing) {
        skipped++;
        continue;
      }
      
      await prisma.candidate.create({
        data: {
          uniqueCandidateId: candidate.uniqueCandidateId,
          voterNumber: candidate.voterNumber,
          ballotNumber: candidate.ballotNumber,
          partyNameArabic: candidate.partyNameArabic,
          partyNameEnglish: candidate.partyNameEnglish,
          candidateSequence: candidate.candidateSequence,
          nominationType: candidate.nominationType,
          governorate: candidate.governorate,
          sex: candidate.sex,
          fullNameArabic: candidate.fullNameArabic,
          fullNameEnglish: candidate.fullNameEnglish,
          email: candidate.email,
          phone: candidate.phone,
          bio: candidate.bio,
          photoUrl: candidate.photoUrl,
          coverPhotoUrl: candidate.coverPhotoUrl,
          verificationStatus: candidate.verificationStatus,
          profileCompletionPercent: candidate.profileCompletionPercent,
          viewsCount: candidate.viewsCount,
          supportersCount: candidate.supportersCount,
          postsCount: candidate.postsCount,
          eventsCount: candidate.eventsCount,
          referralCode: candidate.referralCode,
          createdAt: new Date(candidate.createdAt),
          updatedAt: new Date(candidate.updatedAt)
        }
      });
      
      imported++;
      
      if (imported % 100 === 0) {
        console.log(`   Imported ${imported}/${candidates.length}...`);
      }
    } catch (error) {
      console.error(`   Error: ${candidate.uniqueCandidateId} - ${error.message}`);
      errors++;
    }
  }
  
  console.log('\n Import Complete!');
  console.log(`   Successfully imported: ${imported}`);
  console.log(`   Skipped duplicates: ${skipped}`);
  console.log(`   Errors: ${errors}`);
  
  await prisma.$disconnect();
}

importCandidates().catch(e => {
  console.error('Fatal error:', e);
  process.exit(1);
});