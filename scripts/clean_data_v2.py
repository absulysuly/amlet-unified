import pandas as pd
import json
import re
from datetime import datetime

# Read CSV
print(" Reading CSV file...")
df = pd.read_csv('E:/HamletUnified/data/candidates.csv', encoding='utf-8-sig')

# Clean the data
print(" Cleaning data...")

candidates = []
for idx, row in df.iterrows():
    # Extract clean values (not Series objects)
    ballot_num = str(row.get('ballotNumber', '')).strip()
    if 'dtype:' in ballot_num or '\n' in ballot_num:
        # Extract just the number
        ballot_num = re.search(r'\d+', ballot_num)
        ballot_num = ballot_num.group() if ballot_num else ''
    
    party_arabic = str(row.get('partyNameArabic', '')).strip()
    if 'dtype:' in party_arabic or '\n' in party_arabic:
        # Extract actual party name
        party_match = re.search(r'ballotNumber\s+(.+?)\n', party_arabic)
        party_arabic = party_match.group(1).strip() if party_match else ''
    
    voter_num = row.get('voterNumber', '')
    if pd.notna(voter_num):
        voter_num = int(voter_num)
    else:
        voter_num = None
    
    # Clean governorate
    gov = str(row.get('governorate', '')).strip()
    gov_map = {
        'The egg': 'Dhi Qar',
        'Babylon': 'Babil',
        'Baghdad': 'Baghdad',
        # Add more mappings as needed
    }
    gov = gov_map.get(gov, gov)
    
    # Clean name
    name_arabic = str(row.get('fullNameArabic', '')).strip()
    name_arabic = re.sub(r'\s+', ' ', name_arabic)  # Remove extra spaces
    name_arabic = name_arabic.replace('\n', ' ').replace('-\n', '')
    
    # Generate clean unique ID
    gov_code = gov[:3].upper() if gov else 'UNK'
    unique_id = f"{gov_code}-{ballot_num}-{voter_num:06d}" if voter_num else f"{gov_code}-{ballot_num}-{idx:06d}"
    
    candidate = {
        'uniqueCandidateId': unique_id,
        'voterNumber': voter_num,
        'ballotNumber': ballot_num,
        'partyNameArabic': party_arabic,
        'partyNameEnglish': str(row.get('partyNameEnglish', '')).strip() if pd.notna(row.get('partyNameEnglish')) else None,
        'candidateSequence': int(row['candidateSequence']) if pd.notna(row.get('candidateSequence')) else None,
        'nominationType': str(row.get('nominationType', '')).strip(),
        'governorate': gov,
        'sex': str(row.get('sex', 'MALE')).strip().upper(),
        'fullNameArabic': name_arabic,
        'fullNameEnglish': str(row.get('fullNameEnglish', '')).strip() if pd.notna(row.get('fullNameEnglish')) else None,
        'email': None,
        'phone': None,
        'bio': None,
        'photoUrl': None,
        'coverPhotoUrl': None,
        'verificationStatus': 'unverified',
        'profileCompletionPercent': 30,
        'viewsCount': 0,
        'supportersCount': 0,
        'postsCount': 0,
        'eventsCount': 0,
        'createdAt': datetime.now().isoformat(),
        'updatedAt': datetime.now().isoformat()
    }
    
    candidates.append(candidate)

# Save clean data
print(f" Saving {len(candidates)} cleaned candidates...")
with open('E:/HamletUnified/data/candidates_cleaned_v2.json', 'w', encoding='utf-8') as f:
    json.dump(candidates, f, ensure_ascii=False, indent=2)

print(f" Successfully cleaned {len(candidates)} candidates!")
print(" Saved to: E:/HamletUnified/data/candidates_cleaned_v2.json")