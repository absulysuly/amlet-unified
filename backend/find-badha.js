const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function findBadha() {
  console.log('\n🔍 SEARCHING FOR البضة (BASRA MISSPELLING)\n');
  console.log('═'.repeat(60));
  
  // Search for any governorate containing these Arabic letters
  const candidates = await prisma.candidate.findMany({
    where: {
      OR: [
        { governorate: { contains: 'بض' } },
        { governorate: { contains: 'البضة' } },
        { voterNumber: { gte: 363, lte: 933 } }
      ]
    },
    select: {
      id: true,
      voterNumber: true,
      governorate: true,
      fullNameArabic: true,
      ballotNumber: true
    },
    take: 10
  });
  
  console.log(`Found ${candidates.length} potential Basra candidates\n`);
  
  if (candidates.length > 0) {
    console.log('Sample records:\n');
    candidates.forEach(c => {
      console.log(`  Voter #${c.voterNumber}: "${c.governorate}"`);
      console.log(`    Name: ${c.fullNameArabic}`);
      console.log(`    Ballot: ${c.ballotNumber}\n`);
    });
    
    // Count by governorate
    const govCount = {};
    candidates.forEach(c => {
      govCount[c.governorate] = (govCount[c.governorate] || 0) + 1;
    });
    
    console.log('═'.repeat(60));
    console.log('\nGrouped by governorate:\n');
    Object.entries(govCount).forEach(([gov, count]) => {
      console.log(`  "${gov}" → ${count} candidates`);
    });
    
  } else {
    console.log('❌ No candidates found with البضة');
    console.log('\nThis means either:');
    console.log('  1. The data was cleaned during import');
    console.log('  2. Those rows were not imported');
    console.log('  3. The voter numbers are different\n');
  }
  
  console.log('\n' + '═'.repeat(60) + '\n');
  
  await prisma.$disconnect();
}

findBadha();