const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function searchAll() {
  console.log('\n📋 ALL GOVERNORATE NAMES IN DATABASE\n');
  console.log('═'.repeat(70));
  
  const govs = await prisma.candidate.groupBy({
    by: ['governorate'],
    _count: true,
    orderBy: { _count: { governorate: 'desc' } }
  });
  
  console.log(`\nTotal unique entries: ${govs.length}\n`);
  
  govs.forEach((g, index) => {
    const hex = Buffer.from(g.governorate, 'utf8').toString('hex');
    console.log(`${(index + 1).toString().padStart(2)}. "${g.governorate}" → ${g._count.toString().padStart(4)} candidates`);
    console.log(`    HEX: ${hex}\n`);
  });
  
  console.log('═'.repeat(70));
  
  // Search specifically for anything with ب (Arabic B)
  console.log('\n🔍 Entries containing Arabic "ب" (Ba):');
  const withBa = govs.filter(g => g.governorate.includes('ب'));
  if (withBa.length > 0) {
    withBa.forEach(g => {
      console.log(`   "${g.governorate}" → ${g._count} candidates`);
    });
  } else {
    console.log('   None found');
  }
  
  // Search for anything starting with B
  console.log('\n🔍 Entries starting with "B" (English):');
  const withB = govs.filter(g => g.governorate.toLowerCase().startsWith('b'));
  if (withB.length > 0) {
    withB.forEach(g => {
      console.log(`   "${g.governorate}" → ${g._count} candidates`);
    });
  } else {
    console.log('   None found');
  }
  
  console.log('\n' + '═'.repeat(70) + '\n');
  
  await prisma.$disconnect();
}

searchAll();