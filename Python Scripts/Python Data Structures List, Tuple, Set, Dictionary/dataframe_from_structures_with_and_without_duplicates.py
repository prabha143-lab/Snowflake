import pandas as pd

columns = ["a", "b", "c"]

# ========== WITHOUT DUPLICATES ==========
print("=== WITHOUT DUPLICATES ===")

data_list = [
    [45.0, 12.0, 78.0],
    (46.0, 56.0, 78.0),
    {34.0, 5.0, 6.0}
]

data_tuple = (
    [45.0, 12.0, 78.0],
    (46.0, 56.0, 78.0),
    {34.0, 5.0, 6.0}
)

data_set = {
    (45.0, 12.0, 78.0),
    (46.0, 56.0, 78.0),
    (34.0, 5.0, 6.0),
    tuple([47.0, 12.0, 78.0]),
    tuple({48.0, 12.0, 78.0})
    #list([49.0, 12.0, 78.0])--TypeError: unhashable type: 'list'
}

data_dict = {
    "row1": (45.0, 12.0, 78.0),
    "row2": {46.0, 56.0, 78.0},
    "row3": [34.0, 5.0, 6.0]
}

df_list = pd.DataFrame(data_list, columns=columns)
df_tuple = pd.DataFrame(data_tuple, columns=columns)
df_set = pd.DataFrame(list(data_set), columns=columns)
df_dict = pd.DataFrame.from_dict(data_dict, orient='index', columns=columns)

df_list["max_value"] = df_list.max(axis=1)
df_tuple["max_value"] = df_tuple.max(axis=1)
df_set["max_value"] = df_set.max(axis=1)
df_dict["max_value"] = df_dict.max(axis=1)

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

data_list_dup = [
    (45.0, 12.0, 78.0),
    (46.0, 56.0, 78.0),
    (34.0, 5.0, 6.0),
    (45.0, 12.0, 78.0),  # duplicate
    (34.0, 5.0, 6.0)     # duplicate
]

data_tuple_dup = (
    (45.0, 12.0, 78.0),
    (46.0, 56.0, 78.0),
    (34.0, 5.0, 6.0),
    (45.0, 12.0, 78.0),  # duplicate
    (34.0, 5.0, 6.0)     # duplicate
)

data_set_dup = {
    (45.0, 12.0, 78.0),
    (46.0, 56.0, 78.0),
    (34.0, 5.0, 6.0),
    (45.0, 12.0, 78.0),  # ignored by set
    (34.0, 5.0, 6.0)     # ignored by set
}

data_dict_dup = {
    "row1": [45.0, 12.0, 78.0],
    "row2": [46.0, 56.0, 78.0],
    "row3": [34.0, 5.0, 6.0],
    "row4": [45.0, 12.0, 78.0],  # duplicate
    "row5": [34.0, 5.0, 6.0]     # duplicate
}

df_list_dup = pd.DataFrame(data_list_dup, columns=columns)
df_tuple_dup = pd.DataFrame(data_tuple_dup, columns=columns)
df_set_dup = pd.DataFrame(list(data_set_dup), columns=columns)
df_dict_dup = pd.DataFrame.from_dict(data_dict_dup, orient='index', columns=columns)

df_list_dup["max_value"] = df_list_dup.max(axis=1)
df_tuple_dup["max_value"] = df_tuple_dup.max(axis=1)
df_set_dup["max_value"] = df_set_dup.max(axis=1)
df_dict_dup["max_value"] = df_dict_dup.max(axis=1)

print("\nDataFrame from LIST with duplicates:")
print(df_list_dup)

print("\nDataFrame from TUPLE with duplicates:")
print(df_tuple_dup)

print("\nDataFrame from SET with duplicates (duplicates removed):")
print(df_set_dup)

print("\nDataFrame from DICTIONARY with duplicates:")
print(df_dict_dup)



**********************OUTPUT ***************************

=== WITHOUT DUPLICATES ===

DataFrame from LIST:
      a     b     c  max_value
0  45.0  12.0  78.0       78.0
1  46.0  56.0  78.0       78.0
2  34.0   5.0   6.0       34.0

DataFrame from TUPLE:
      a     b     c  max_value
0  45.0  12.0  78.0       78.0
1  46.0  56.0  78.0       78.0
2  34.0   5.0   6.0       34.0

DataFrame from SET:
      a     b     c  max_value
0  48.0  12.0  78.0       78.0
1  45.0  12.0  78.0       78.0
2  34.0   5.0   6.0       34.0
3  46.0  56.0  78.0       78.0
4  47.0  12.0  78.0       78.0

DataFrame from DICTIONARY:
         a     b     c  max_value
row1  45.0  12.0  78.0       78.0
row2  56.0  46.0  78.0       78.0
row3  34.0   5.0   6.0       34.0


=== WITH DUPLICATES ===

DataFrame from LIST with duplicates:
      a     b     c  max_value
0  45.0  12.0  78.0       78.0
1  46.0  56.0  78.0       78.0
2  34.0   5.0   6.0       34.0
3  45.0  12.0  78.0       78.0
4  34.0   5.0   6.0       34.0

DataFrame from TUPLE with duplicates:
      a     b     c  max_value
0  45.0  12.0  78.0       78.0
1  46.0  56.0  78.0       78.0
2  34.0   5.0   6.0       34.0
3  45.0  12.0  78.0       78.0
4  34.0   5.0   6.0       34.0

DataFrame from SET with duplicates (duplicates removed):
      a     b     c  max_value
0  34.0   5.0   6.0       34.0
1  45.0  12.0  78.0       78.0
2  46.0  56.0  78.0       78.0

DataFrame from DICTIONARY with duplicates:
         a     b     c  max_value
row1  45.0  12.0  78.0       78.0
row2  46.0  56.0  78.0       78.0
row3  34.0   5.0   6.0       34.0
row4  45.0  12.0  78.0       78.0
row5  34.0   5.0   6.0       34.0

=== Code Execution Successful ===