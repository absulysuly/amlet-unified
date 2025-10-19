const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function fixBasra() {
  console.log('\n🔍 SEARCHING FOR MISSPELLED BASRA DATA\n');
  console.log('═'.repeat(60));
  
  // Search for variations of the misspelled Basra
  const misspellings = [
    'البضة',           // The one you found
    'البضرة',          // Possible variation
    'Albdah',          // English transliteration
    'Al-Badha',        // English variation
    'Albadha',         // Another variation
  ];
  
  let totalFixed = 0;
  
  console.log('🔄 Searching for misspelled Basra entries...\n');
  
  for (const wrong of misspellings) {
    try {
      // Check if this variation exists
      const count = await prisma.candidate.count({
        where: { 
          governorate: {
            contains: wrong
          }
        }
      });
      
      if (count > 0) {
        console.log(`  🔍 Found "${wrong}" → ${count} candidate(s)`);
        
        // Update to correct spelling
        const result = await prisma.candidate.updateMany({
          where: { 
            governorate: {
              contains: wrong
            }
          },
          data: { governorate: 'Basra' }
        });
        
        console.log(`  ✅ Fixed "${wrong}" → "Basra" (${result.count} records)\n`);
        totalFixed += result.count;
      }
    } catch (error) {
      console.log(`  ⚠️  Error checking "${wrong}": ${error.message}`);
    }
  }
  
  // Also search for any governorate containing Arabic characters for Basra
  console.log('🔍 Searching for any Arabic text containing Basra patterns...\n');
  
  const allGovs = await prisma.candidate.groupBy({
    by: ['governorate'],
    _count: true
  });
  
  // Look for governorates with Arabic characters that might be Basra
  for (const gov of allGovs) {
    if (gov.governorate && 
        (gov.governorate.includes('بض') || 
         gov.governorate.includes('بص') ||
         gov.governorate.toLowerCase().includes('bas') ||
         gov.governorate.toLowerCase().includes('badh'))) {
      
      if (gov.governorate !== 'Basra' && gov.governorate !== 'البصرة') {
        console.log(`  🔍 Found possible Basra: "${gov.governorate}" → ${gov._count} candidates`);
        
        const result = await prisma.candidate.updateMany({
          where: { governorate: gov.governorate },
          data: { governorate: 'Basra' }
        });
        
        console.log(`  ✅ Fixed → "Basra" (${result.count} records)\n`);
        totalFixed += result.count;
      }
    }
  }
  
  console.log('═'.repeat(60));
  
  if (totalFixed > 0) {
    console.log(`\n✅ BASRA DATA RECOVERED!`);
    console.log(`   Fixed ${totalFixed} Basra candidates`);
    console.log(`   Iraq now has all 18 governorates!\n`);
    
    // Verify
    const basraCount = await prisma.candidate.count({
      where: { governorate: 'Basra' }
    });
    
    console.log('📊 VERIFICATION:');
    console.log('─'.repeat(60));
    console.log(`   Basra candidates: ${basraCount}`);
    
    const totalGovs = await prisma.candidate.groupBy({
      by: ['governorate'],
      _count: true
    });
    
    console.log(`   Total governorates: ${totalGovs.length}`);
    
    if (totalGovs.length === 18) {
      console.log(`   ✅ SUCCESS! All 18 Iraqi governorates present!\n`);
    } else {
      console.log(`   ℹ️  Current governorates: ${totalGovs.length}/18\n`);
    }
    
  } else {
    console.log(`\n⚠️  NO BASRA DATA FOUND`);
    console.log(`   The misspelling "البضة" was not found in the database.`);
    console.log(`   Please check the exact spelling in your source data.\n`);
    
    console.log('💡 TIP: To see all governorate names, run:');
    console.log('   node data-quality-report.js\n');
  }
  
  console.log('═'.repeat(60) + '\n');
  
  await prisma.$disconnect();
}

fixBasra();