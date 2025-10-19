const XLSX = require('xlsx');

console.log('\n📊 ANALYZING EXCEL FILE\n');
console.log('═'.repeat(70));

try {
  const workbook = XLSX.readFile('E:\\HamletUnified\\Candidate_ballot_numbers.xlsx');
  
  console.log(`\n📋 Sheet Names: ${workbook.SheetNames.join(', ')}\n`);
  
  workbook.SheetNames.forEach(sheetName => {
    console.log(`\n📄 Sheet: "${sheetName}"`);
    console.log('─'.repeat(70));
    
    const sheet = workbook.Sheets[sheetName];
    const data = XLSX.utils.sheet_to_json(sheet);
    
    console.log(`   Total rows: ${data.length}`);
    
    if (data.length > 0) {
      console.log(`   Columns: ${Object.keys(data[0]).join(', ')}`);
      
      // Check for governorate column
      const govCol = Object.keys(data[0]).find(k => 
        k.toLowerCase().includes('gov') || 
        k.toLowerCase().includes('محافظة') ||
        k.toLowerCase().includes('province')
      );
      
      if (govCol) {
        console.log(`\n   Governorate column: "${govCol}"`);
        
        // Count unique governorates
        const govs = {};
        data.forEach(row => {
          const gov = row[govCol];
          if (gov) {
            govs[gov] = (govs[gov] || 0) + 1;
          }
        });
        
        console.log(`\n   Unique governorates: ${Object.keys(govs).length}`);
        
        // Search for Basra
        const basraVariations = Object.keys(govs).filter(g => 
          g.toLowerCase().includes('bas') || 
          g.includes('بص') || 
          g.includes('بض')
        );
        
        if (basraVariations.length > 0) {
          console.log(`\n   ✅ BASRA FOUND IN EXCEL!`);
          basraVariations.forEach(b => {
            console.log(`      "${b}" → ${govs[b]} candidates`);
          });
        } else {
          console.log(`\n   ❌ BASRA NOT FOUND in this sheet`);
        }
        
        // Show first 20 governorates
        console.log(`\n   All governorates in this sheet:`);
        Object.entries(govs)
          .sort((a, b) => b[1] - a[1])
          .slice(0, 20)
          .forEach(([gov, count]) => {
            console.log(`      ${gov.padEnd(30)} → ${count.toString().padStart(4)} candidates`);
          });
      } else {
        console.log(`\n   ⚠️  No governorate column found`);
      }
    }
  });
  
  console.log('\n' + '═'.repeat(70) + '\n');
  
} catch (error) {
  console.error('❌ Error reading Excel file:', error.message);
  console.log('\nMake sure the file exists at:');
  console.log('E:\\HamletUnified\\Candidate_ballot_numbers.xlsx\n');
}