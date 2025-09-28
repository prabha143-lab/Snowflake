import csv
import os

# Step 1: Define the local CSV path
csv_path = r"C:\Snowflake_Files_ForPractice\Day1.csv"

# Step 2: Check if the file exists
if not os.path.exists(csv_path):
    raise FileNotFoundError(f"❌ File not found at: {csv_path}")
print("✅ File found. Reading CSV...")

# Step 3: Read the CSV file
rows = []
try:
    with open(csv_path, mode='r', encoding='utf-8') as file:
        reader = csv.DictReader(file)
        for row in reader:
            rows.append(row)
except Exception as e:
    raise Exception(f"🚫 Error reading CSV: {e}")

# Step 4: Separate valid and skipped rows
valid_rows = []
skipped_rows = []

for row in rows:
    if row.get("id") and row.get("name"):
        valid_rows.append(row)
    else:
        skipped_rows.append(row)

# Step 5: Log skipped rows
if skipped_rows:
    print("\n⚠️ Skipped rows due to missing 'id' or 'name':")
    for r in skipped_rows:
        print(r)

# Step 6: Show valid rows
print("\n✅ Valid rows:")
for r in valid_rows:
    print(r)

# Step 7: Summary stats
print(f"\n📊 Summary:")
print(f"Total rows: {len(rows)}")
print(f"Valid rows: {len(valid_rows)}")
print(f"Skipped rows: {len(skipped_rows)}")
