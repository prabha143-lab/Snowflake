import pandas as pd

# Step 1: Define the file path
file_path = 'C:/Pythontestfiles/mymelt.csv'

# Step 2: Read the CSV file
df = pd.read_csv(file_path)

# Step 3: Reshape the data from wide to long format
long_df = df.melt(id_vars=['hotelname'], var_name='city', value_name='collection')

# Step 4: Print the result in the desired format
print("hotelname\tcity\tcollection")
for _, row in long_df.iterrows():
    print(f"{row['hotelname']}\t{row['city']}\t{row['collection']}")
