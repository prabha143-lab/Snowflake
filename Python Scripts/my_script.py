import pandas as pd
import os

# Step 1: Define the local CSV path
csv_path = r"C:\Snowflake_Files_ForPractice\Day1.csv"

# Step 2: Check if the file exists
if not os.path.exists(csv_path):
    raise FileNotFoundError(f"❌ File not found at: {csv_path}")
print("✅ File found. Reading CSV...")

# Step 3: Read the CSV file
try:
    df = pd.read_csv(csv_path, encoding='utf-8')
except Exception as e:
    raise Exception(f"🚫 Error reading CSV: {e}")

# Step 4: Drop rows with missing 'id' or 'name'
valid_rows = df.dropna(subset=["id", "name"])
skipped_rows = df[df[["id", "name"]].isnull().any(axis=1)]

# Step 5: Log skipped rows
if not skipped_rows.empty:
    print("\⚠️ Skipped rows due to missing 'id' or 'name':")
    print(skipped_rows)

# Step 6: Show valid rows
print("\n✅ Valid rows:")
print(valid_rows)

# Step 7: Summary stats
print(f"\n📊 Summary:")
print(f"Total rows: {len(df)}")
print(f"Valid rows: {len(valid_rows)}")
print(f"Skipped rows: {len(skipped_rows)}")
