import pandas as pd
import json
import re
from datetime import datetime
import os

INPUT_FILE = r"E:\HamletUnified\full_consolidation\candidates\master\MASTER_CANDIDATES_20251015_014042.csv"
OUTPUT_JSON = r"E:\HamletUnified\data\candidates_production_ready.json"
OUTPUT_CSV = r"E:\HamletUnified\data\candidates_production_ready.csv"

print("🚀 Starting Master Candidate Processing...")
print(f"📂 Input: {INPUT_FILE}")

try:
    df = pd.read_csv(INPUT_FILE, encoding='utf-8')
except:
    df = pd.read_csv(INPUT_FILE, encoding='latin-1')

print(f"✅ Loaded {len(df)} candidates")

df.columns = df.columns.str.replace('\n', ' ').str.replace('\r', ' ').str.strip()
df.columns = [' '.join(col.split()) for col in df.columns]

print("\n📋 Column Names After Cleaning:")
for col in df.columns:
    print(f"   - {col}")

def map_column(col):
    col_lower = col.lower().replace(' ', '').replace('-', '').replace('\n', '')
    if 'ballot' in col_lower or col == 'A':
        return 'ballotNumber'
    elif 'nameonballot' in col_lower or 'party' in col_lower:
        return 'partyNameOriginal'
    elif 'sequence' in col_lower:
        return 'candidateSequence'
    elif 'type' in col_lower and 'nomination' in col_lower:
        return 'nominationType'
    elif 'electoral' in col_lower or 'district' in col_lower:
        return 'governorate'
    elif col_lower == 'sex':
        return 'sex'
    elif 'fullname' in col_lower or 'candidatesful' in col_lower:
        return 'fullNameOriginal'
    elif 'voter' in col_lower and 'number' in col_lower:
        return 'voterNumber'
    elif 'source' in col_lower:
        return 'sourceFile'
    else:
        return col

df.columns = [map_column(col) for col in df.columns]

print("\n✅ Mapped to Database Schema:")
for col in df.columns:
    print(f"   - {col}")

def generate_unique_id(row):
    gov_code = str(row.get('governorate', 'UNK'))[:3].upper()
    gov_code = re.sub(r'[^A-Z]', '', gov_code) or 'UNK'
    ballot = str(row.get('ballotNumber', '000')).zfill(3)
    voter = str(row.get('voterNumber', '0')).zfill(6)
    return f"{gov_code}-{ballot}-{voter}"

candidates = []
errors = []

for idx, row in df.iterrows():
    try:
        unique_id = generate_unique_id(row)
        sex_value = str(row.get('sex', '')).strip().lower()
        if 'male' in sex_value and 'female' not in sex_value:
            sex = 'MALE'
        elif 'female' in sex_value:
            sex = 'FEMALE'
        else:
            sex = 'UNKNOWN'
        
        candidate = {
            'uniqueCandidateId': unique_id,
            'voterNumber': int(row.get('voterNumber', 0)) if pd.notna(row.get('voterNumber')) else None,
            'ballotNumber': str(row.get('ballotNumber', '')),
            'partyNameArabic': str(row.get('partyNameOriginal', '')),
            'partyNameEnglish': None,
            'candidateSequence': int(row.get('candidateSequence', 0)) if pd.notna(row.get('candidateSequence')) else None,
            'nominationType': str(row.get('nominationType', '')),
            'governorate': str(row.get('governorate', '')),
            'sex': sex,
            'fullNameArabic': str(row.get('fullNameOriginal', '')),
            'fullNameEnglish': None,
            'email': None,
            'phone': None,
            'bio': None,
            'photoUrl': None,
            'coverPhotoUrl': None,
            'verificationStatus': 'unverified',
            'verificationDocuments': [],
            'verifiedAt': None,
            'verifiedBy': None,
            'profileCompletionPercent': 30,
            'viewsCount': 0,
            'supportersCount': 0,
            'postsCount': 0,
            'eventsCount': 0,
            'sourceFile': str(row.get('sourceFile', '')),
            'metadataH1': str(row.get('H1', '')) if 'H1' in df.columns else None,
            'metadataH2': str(row.get('H2', '')) if 'H2' in df.columns else None,
            'createdAt': datetime.now().isoformat(),
            'updatedAt': datetime.now().isoformat(),
            'lastActiveAt': None
        }
        
        candidates.append(candidate)
        
        if (idx + 1) % 1000 == 0:
            print(f"✅ Processed {idx + 1}/{len(df)} candidates...")
            
    except Exception as e:
        errors.append({'row': idx, 'error': str(e), 'data': row.to_dict()})
        print(f"⚠️ Error on row {idx}: {e}")

print(f"\n🎉 Processing Complete!")
print(f"✅ Successfully processed: {len(candidates)}")
print(f"❌ Errors: {len(errors)}")

os.makedirs(os.path.dirname(OUTPUT_JSON), exist_ok=True)

with open(OUTPUT_JSON, 'w', encoding='utf-8') as f:
    json.dump(candidates, f, ensure_ascii=False, indent=2)

print(f"💾 Saved JSON: {OUTPUT_JSON}")

df_output = pd.DataFrame(candidates)
df_output.to_csv(OUTPUT_CSV, index=False, encoding='utf-8')
print(f"💾 Saved CSV: {OUTPUT_CSV}")

if errors:
    error_file = r"E:\HamletUnified\data\processing_errors.json"
    with open(error_file, 'w', encoding='utf-8') as f:
        json.dump(errors, f, ensure_ascii=False, indent=2)
    print(f"⚠️ Error log saved: {error_file}")

print("\n✅ ALL DONE! Ready for database import.")
