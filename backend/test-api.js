const API = 'http://localhost:4001';
console.log('\n🧪 Testing Hamlet API...\n');
const tests = [
  { name: 'Health', url: API + '/' },
  { name: 'Candidates', url: API + '/api/candidates?limit=5' },
  { name: 'Search', url: API + '/api/candidates/search?governorate=Baghdad' },
  { name: 'Governorates', url: API + '/api/governorates' },
  { name: 'Stats', url: API + '/api/stats' }
];
async function run() {
  let pass = 0;
  for (const t of tests) {
    try {
      const r = await fetch(t.url);
      const d = await r.json();
      console.log('✅ ' + t.name);
      pass++;
    } catch (e) {
      console.log('❌ ' + t.name);
    }
  }
  console.log('\n📊 ' + pass + '/' + tests.length + ' passed\n');
}
setTimeout(run, 2000);