import sqlite3
import csv
import requests
from urllib.parse import urlparse
from datetime import datetime

# Configuration
VALID_DOMAINS = {
    'twitter.com': 'Twitter',
    'facebook.com': 'Facebook',
    'instagram.com': 'Instagram',
    'linkedin.com': 'LinkedIn'
}
TIMEOUT = 3  # seconds

def validate_and_update():
    conn = sqlite3.connect('election.db')
    cursor = conn.cursor()
    
    # Create validation report
    with open('validation_report.csv', 'w', newline='', encoding='utf-8') as report_file:
        writer = csv.writer(report_file)
        writer.writerow([
            'ID', 'Name', 'Platform', 'URL', 'Status', 
            'HTTP Code', 'Valid Domain', 'Timestamp'
        ])
        
        # Get all candidates with contacts
        cursor.execute("""
        SELECT c.candidate_id, c.full_name_en, 
               co.twitter, co.facebook, co.instagram, co.linkedin
        FROM candidates c
        LEFT JOIN candidate_contacts co ON c.candidate_id = co.candidate_id
        WHERE c.governorate IN ('بغداد', 'أربيل')
        """)
        
        for row in cursor.fetchall():
            candidate_id, name = row[0], row[1]
            
            for i, platform in enumerate(['Twitter', 'Facebook', 'Instagram', 'LinkedIn'], 2):
                url = row[i]
                if not url:
                    continue
                    
                # Validate domain
                domain = urlparse(url).netloc
                valid_domain = any(d in domain for d in VALID_DOMAINS)
                
                # Validate URL
                http_status = 'N/A'
                try:
                    response = requests.head(url, timeout=TIMEOUT, allow_redirects=True)
                    http_status = response.status_code
                    status = 'VALID' if response.status_code == 200 else 'INVALID'
                except:
                    status = 'ERROR'
                
                # Write to report
                writer.writerow([
                    candidate_id, name, platform, url, status,
                    http_status, valid_domain, datetime.now()
                ])
                
                # Update database if contact exists
                if any(row[2:6]):  # If any social media exists
                    cursor.execute("""
                    INSERT OR REPLACE INTO candidate_contacts 
                    (candidate_id, twitter, facebook, instagram, linkedin, 
                     verification_status, last_verified)
                    VALUES (?, ?, ?, ?, ?, ?, ?)
                    """, (candidate_id, row[2], row[3], row[4], row[5], status, datetime.now()))
    
    conn.commit()
    conn.close()
    print("Validation complete. Report saved to validation_report.csv")

if __name__ == "__main__":
    validate_and_update()
