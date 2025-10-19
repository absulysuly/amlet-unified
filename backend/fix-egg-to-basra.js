const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function fixEggToBasra() {
  console.log('\n🔧 RENAMING "The egg" TO "Basra"\n');
  console.log('═'.repeat(60));
  
  // First, check if "The egg" exists
  const eggCount = await prisma.candidate.count({
    where: { governorate: 'The egg' }
  });
  
  console.log(`\nFound ${eggCount} candidates labeled as "The egg"\n`);
  
  if (eggCount > 0) {
    // Update them to Basra
    const result = await prisma.candidate.updateMany({
      where: { governorate: 'The egg' },
      data: { governorate: 'Basra' }
    });
    
    console.log('═'.repeat(60));
    console.log(`\n✅ SUCCESS! Updated ${result.count} candidates`);
    console.log('   "The egg" → "Basra"\n');
    
    // Verify
    const basraCount = await prisma.candidate.count({
      where: { governorate: 'Basra' }
    });
    
    console.log(`📊 VERIFICATION:`);
    console.log(`   Basra now has: ${basraCount} candidates\n`);
    
    // Check total governorates
    const totalGovs = await prisma.candidate.groupBy({
      by: ['governorate'],
      _count: true
    });
    
    console.log(`   Total governorates: ${totalGovs.length}`);
    
    if (totalGovs.length === 18) {
      console.log(`   🎉 ALL 18 IRAQI GOVERNORATES COMPLETE!\n`);
    }
    
  } else {
    console.log('❌ No candidates found with "The egg"');
    console.log('   Searching for similar variations...\n');
    
    const allGovs = await prisma.candidate.groupBy({
      by: ['governorate'],
      _count: true,
      orderBy: { _count: { governorate: 'desc' } }
    });
    
    console.log('All governorates in database:\n');
    allGovs.forEach(g => {
      console.log(`   "${g.governorate}" → ${g._count} candidates`);
    });
  }
  
  console.log('\n' + '═'.repeat(60) + '\n');
  
  await prisma.$disconnect();
}

fixEggToBasra();