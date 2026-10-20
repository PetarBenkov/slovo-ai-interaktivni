const admin = require('firebase-admin');
const fs = require('fs');
const path = require('path');

console.log('1. Инициализиране...');

const serviceAccountPath = path.join(__dirname, 'serviceAccountKey.json');
if (!fs.existsSync(serviceAccountPath)) {
  console.error('❌ ГРЕШКА: Файлът serviceAccountKey.json липсва!');
  process.exit(1);
}

const serviceAccount = JSON.parse(fs.readFileSync(serviceAccountPath, 'utf8'));

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

const rulesDataPath = path.join(__dirname, 'rulesData.json');
if (!fs.existsSync(rulesDataPath)) {
  console.error('❌ ГРЕШКА: Файлът rulesData.json липсва!');
  process.exit(1);
}

const rulesData = JSON.parse(fs.readFileSync(rulesDataPath, 'utf8'));

async function importRules() {
  console.log('🚀 Започва качването във Firebase Firestore...');

  const rulesCollection = db.collection('rules');
  let count = 0;

  const items = Array.isArray(rulesData) ? rulesData : [rulesData];

  for (const item of items) {
    const docId = item.id || `rule-${count + 1}`;
    await rulesCollection.doc(docId).set(item, { merge: true });
    count++;
    console.log(`✅ [${count}/${items.length}] Качено: ${item.title || docId}`);
  }

  console.log(`\n🎉 Успешно качени ${count} правила!`);
  process.exit(0);
}

importRules().catch((error) => {
  console.error('❌ Грешка при качването:', error);
  process.exit(1);
});