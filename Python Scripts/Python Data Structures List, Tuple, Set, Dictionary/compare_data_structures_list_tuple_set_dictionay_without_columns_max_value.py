import pandas as pd

# ========== WITHOUT DUPLICATES ==========
print("=== WITHOUT DUPLICATES ===")

# Data definitions
data_list = [
    (45.0, 12.0, 78.0),
    (46.0, 56.0, 78.0),
    (34.0, 5.0, 6.0)
]

data_tuple = (
    (45.0, 12.0, 78.0),
    (46.0, 56.0, 78.0),
    (34.0, 5.0, 6.0)
)

data_set = {
    (45.0, 12.0, 78.0),
    (46.0, 56.0, 78.0),
    (34.0, 5.0, 6.0)
}

data_dict = {
    "row1": [45.0, 12.0, 78.0],
    "row2": [46.0, 56.0, 78.0],
    "row3": [34.0, 5.0, 6.0]
}

# Create DataFrames without specifying column names
df_list = pd.DataFrame(data_list)
df_tuple = pd.DataFrame(data_tuple)
df_set = pd.DataFrame(list(data_set))
df_dict = pd.DataFrame.from_dict(data_dict, orient='index')

# Add max_value column using default column indices
for df in [df_list, df_tuple, df_set, df_dict]:
    df["max_value"] = df.max(axis=1)

# Display results
print("\nDataFrame from LIST:")
print(df_list)

print("\nDataFrame from TUPLE:")
print(df_tuple)

print("\nDataFrame from SET:")
print(df_set)

print("\nDataFrame from DICTIONARY:")
print(df_dict)

# ========== WITH DUPLICATES ==========
print("\n\n=== WITH DUPLICATES ===")

# Data with duplicates
data_list_dup = [
    (45.0, 12.0, 78.0),
    (46.0, 56.0, 78.0),
    (34.0, 5.0, 6.0),
    (45.0, 12.0, 78.0),
    (34.0, 5.0, 6.0)
]

data_tuple_dup = (
    (45.0, 12.0, 78.0),
    (46.0, 56.0, 78.0),
    (34.0, 5.0, 6.0),
    (45.0, 12.0, 78.0),
    (34.0, 5.0, 6.0)
)

data_set_dup = {
    (45.0, 12.0, 78.0),
    (46.0, 56.0, 78.0),
    (34.0, 5.0, 6.0),
    (45.0, 12.0, 78.0),
    (34.0, 5.0, 6.0)
}

data_dict_dup = {
    "row1": [45.0, 12.0, 78.0],
    "row2": [46.0, 56.0, 78.0],
    "row3": [34.0, 5.0, 6.0],
    "row4": [45.0, 12.0, 78.0],
    "row5": [34.0, 5.0, 6.0]
}

# Create DataFrames without specifying column names
df_list_dup = pd.DataFrame(data_list_dup)
df_tuple_dup = pd.DataFrame(data_tuple_dup)
df_set_dup = pd.DataFrame(list(data_set_dup))
df_dict_dup = pd.DataFrame.from_dict(data_dict_dup, orient='index')

# Add max_value column using default column indices
for df in [df_list_dup, df_tuple_dup, df_set_dup, df_dict_dup]:
    df["max_value"] = df.max(axis=1)

# Display results
print("\nDataFrame from LIST with duplicates:")
print(df_list_dup)

print("\nDataFrame from TUPLE with duplicates:")
print(df_tuple_dup)

print("\nDataFrame from SET with duplicates (duplicates removed):")
print(df_set_dup)

print("\nDataFrame from DICTIONARY with duplicates:")
print(df_dict_dup)


***************OUTPUT *******************************

=== WITHOUT DUPLICATES ===

DataFrame from LIST:
      0     1     2  max_value
0  45.0  12.0  78.0       78.0
1  46.0  56.0  78.0       78.0
2  34.0   5.0   6.0       34.0

DataFrame from TUPLE:
      0     1     2  max_value
0  45.0  12.0  78.0       78.0
1  46.0  56.0  78.0       78.0
2  34.0   5.0   6.0       34.0

DataFrame from SET:
      0     1     2  max_value
0  34.0   5.0   6.0       34.0
1  45.0  12.0  78.0       78.0
2  46.0  56.0  78.0       78.0

DataFrame from DICTIONARY:
         0     1     2  max_value
row1  45.0  12.0  78.0       78.0
row2  46.0  56.0  78.0       78.0
row3  34.0   5.0   6.0       34.0


=== WITH DUPLICATES ===

DataFrame from LIST with duplicates:
      0     1     2  max_value
0  45.0  12.0  78.0       78.0
1  46.0  56.0  78.0       78.0
2  34.0   5.0   6.0       34.0
3  45.0  12.0  78.0       78.0
4  34.0   5.0   6.0       34.0

DataFrame from TUPLE with duplicates:
      0     1     2  max_value
0  45.0  12.0  78.0       78.0
1  46.0  56.0  78.0       78.0
2  34.0   5.0   6.0       34.0
3  45.0  12.0  78.0       78.0
4  34.0   5.0   6.0       34.0

DataFrame from SET with duplicates (duplicates removed):
      0     1     2  max_value
0  34.0   5.0   6.0       34.0
1  45.0  12.0  78.0       78.0
2  46.0  56.0  78.0       78.0

DataFrame from DICTIONARY with duplicates:
         0     1     2  max_value
row1  45.0  12.0  78.0       78.0
row2  46.0  56.0  78.0       78.0
row3  34.0   5.0   6.0       34.0
row4  45.0  12.0  78.0       78.0
row5  34.0   5.0   6.0       34.0

=== Code Execution Successful ===