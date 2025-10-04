# -----------------------------
# Max/Min Extraction from Collections
# -----------------------------

# Functions for reuse
def get_max_from_collection(collection):
    return [max(item) for item in collection]

def get_min_from_collection(collection):
    return [min(item) for item in collection]

def get_max_from_dict_values(d):
    return {k: max(v) for k, v in d.items()}

def get_min_from_dict_values(d):
    return {k: min(v) for k, v in d.items()}

# -----------------------------
# List of Lists
# -----------------------------
list_of_lists = [[1, 2, 11], [12, 34, 89], [12, 34, 23, 67]]
max_values_list = get_max_from_collection(list_of_lists)
print("list_of_lists maximum from each list =>", max_values_list)

print()

min_values_list = get_min_from_collection(list_of_lists)
print("list_of_lists minimum from each list =>", min_values_list)

print()

# -----------------------------
# Tuple of Tuples
# -----------------------------
tuple_of_tuples = ((1, 2, 11), (12, 34, 89), (12, 34, 23, 67))
max_values_tuple = get_max_from_collection(tuple_of_tuples)
print("tuple_of_tuples maximum from each tuple =>", max_values_tuple)

print()

min_values_tuple = get_min_from_collection(tuple_of_tuples)
print("tuple_of_tuples minimum from each tuple =>", min_values_tuple)

print()

# -----------------------------
# List of Sets
# -----------------------------
list_of_sets = [{1, 2, 11}, {12, 34, 89}, {12, 34, 23, 67}]
max_values_set = get_max_from_collection(list_of_sets)
print("list_of_sets maximum from each set =>", max_values_set)

print()

min_values_set = get_min_from_collection(list_of_sets)
print("list_of_sets minimum from each set =>", min_values_set)

print()

# -----------------------------
# Dictionary of Lists
# -----------------------------
dict_of_lists = {
    'a': [1, 2, 11],
    'b': [12, 34, 89],
    'c': [12, 34, 23, 67]
}
max_values_dict = get_max_from_dict_values(dict_of_lists)
print("dict_of_lists maximum from each list =>", max_values_dict)

print()

min_values_dict = get_min_from_dict_values(dict_of_lists)
print("dict_of_lists minimum from each list =>", min_values_dict)

print()

# -----------------------------
# Summary
# -----------------------------
print("--- Summary of Results ---")
print("Max from list_of_lists:", max_values_list)
print("Min from list_of_lists:", min_values_list)
print("Max from tuple_of_tuples:", max_values_tuple)
print("Min from tuple_of_tuples:", min_values_tuple)
print("Max from list_of_sets:", max_values_set)
print("Min from list_of_sets:", min_values_set)
print("Max from dict_of_lists:", max_values_dict)
print("Min from dict_of_lists:", min_values_dict)


******************************OUTPUT ************************

list_of_lists maximum from each list => [11, 89, 67]

list_of_lists minimum from each list => [1, 12, 12]

tuple_of_tuples maximum from each tuple => [11, 89, 67]

tuple_of_tuples minimum from each tuple => [1, 12, 12]

list_of_sets maximum from each set => [11, 89, 67]

list_of_sets minimum from each set => [1, 12, 12]

dict_of_lists maximum from each list => {'a': 11, 'b': 89, 'c': 67}

dict_of_lists minimum from each list => {'a': 1, 'b': 12, 'c': 12}

--- Summary of Results ---
Max from list_of_lists: [11, 89, 67]
Min from list_of_lists: [1, 12, 12]
Max from tuple_of_tuples: [11, 89, 67]
Min from tuple_of_tuples: [1, 12, 12]
Max from list_of_sets: [11, 89, 67]
Min from list_of_sets: [1, 12, 12]
Max from dict_of_lists: {'a': 11, 'b': 89, 'c': 67}
Min from dict_of_lists: {'a': 1, 'b': 12, 'c': 12}

=== Code Execution Successful ===
