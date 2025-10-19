const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function analyzeData() {
  console.log('\n🔍 HAMLET ELECTION DATA QUALITY REPORT\n');
  console.log('═'.repeat(60));
  
  // Get all governorates
  const govs = await prisma.candidate.groupBy({
    by: ['governorate'],
    _count: true,
    orderBy: { _count: { governorate: 'desc' } }
  });
  
  console.log('\n📊 GOVERNORATE ANALYSIS:');
  console.log('─'.repeat(60));
  console.log(`Total unique governorate entries: ${govs.length}`);
  console.log(`Expected: 18`);
  console.log(`Data quality issues: ${govs.length - 18}\n`);
  
  // Official 18 governorates
  const official = [
    'Baghdad', 'Basra', 'Nineveh', 'Dhi Qar', 'Anbar', 
    'Babil', 'Diyala', 'Karbala', 'Kirkuk', 'Maysan',
    'The two', 'Najaf', 'Al-Qadisiyah', 'Saladin', 
    'Sulaymaniyah', 'Wasit', 'Erbil', 'Dohuk'
  ];
  
  console.log('✅ CLEAN DATA (Official Governorates):');
  console.log('─'.repeat(60));
  let cleanTotal = 0;
  govs.forEach(g => {
    const isOfficial = official.some(o => 
      g.governorate && g.governorate.trim().toLowerCase().startsWith(o.toLowerCase().substring(0, 5))
    );
    if (isOfficial && g._count > 50) {
      console.log(`  ${g.governorate.padEnd(25)} → ${g._count.toString().padStart(5)} candidates`);
      cleanTotal += g._count;
    }
  });
  
  console.log('\n❌ CORRUPTED DATA (Needs cleaning):');
  console.log('─'.repeat(60));
  let corruptedTotal = 0;
  govs.forEach(g => {
    if (g._count <= 5 || g.governorate.length > 25) {
      console.log(`  "${g.governorate}" → ${g._count} candidate(s)`);
      corruptedTotal += g._count;
    }
  });
  
  console.log('\n📈 SUMMARY:');
  console.log('─'.repeat(60));
  console.log(`  Clean records:     ${cleanTotal.toString().padStart(5)} (${((cleanTotal/7751)*100).toFixed(1)}%)`);
  console.log(`  Corrupted records: ${corruptedTotal.toString().padStart(5)} (${((corruptedTotal/7751)*100).toFixed(1)}%)`);
  console.log(`  Total:             ${(cleanTotal + corruptedTotal).toString().padStart(5)}`);
  
  console.log('\n💡 RECOMMENDATION:');
  console.log('─'.repeat(60));
  console.log('  • Clean the corrupted entries');
  console.log('  • Standardize governorate names');
  console.log('  • Merge duplicates into 18 official governorates');
  console.log('\n' + '═'.repeat(60) + '\n');
  
  await prisma.$disconnect();
}

analyzeData();