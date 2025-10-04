# Define a list of lists and find the maximum value from each inner list
list_of_lists1 = [[1, 2, 11], [12, 34, 89], [12, 34, 23, 67]]
max_values1 = [max(t) for t in list_of_lists1]  # Use max() to get the largest number in each list
print("list_of_lists1 maximum from each list =>", max_values1)

print()  # Print a blank line for better readability

# Define another list of lists and find the minimum value from each inner list
list_of_lists2 = [[1, 2, 11], [12, 34, 89], [12, 34, 23, 67]]
min_values2 = [min(t) for t in list_of_lists2]  # Use min() to get the smallest number in each list
print("list_of_lists2 minimum from each list =>", min_values2)

print()

# Define a tuple of tuples and find the maximum value from each inner tuple
list_of_tuples1 = ((1, 2, 11), (12, 34, 89), (12, 34, 23, 67))
max_values3 = [max(t) for t in list_of_tuples1]  # Use max() to get the largest number in each tuple
print("list_of_tuples1 maximum from each list =>", max_values3)

print()

# Define another tuple of tuples and find the minimum value from each inner tuple
list_of_tuples2 = ((1, 2, 11), (12, 34, 89), (12, 34, 23, 67))
min_values4 = [min(t) for t in list_of_tuples2]  # Use min() to get the smallest number in each tuple
print("list_of_tuples2 minimum from each list =>", min_values4)

print()

# Define a list of sets and find the maximum value from each set
list_of_sets1 = [{1, 2, 11}, {12, 34, 89}, {12, 34, 23, 67}]
max_values5 = [max(s) for s in list_of_sets1]  # Use max() to get the largest number in each set
print("list_of_sets1 maximum from each set =>", max_values5)

print()

# Define another list of sets and find the minimum value from each set
list_of_sets2 = [{1, 2, 11}, {12, 34, 89}, {12, 34, 23, 67}]
min_values6 = [min(s) for s in list_of_sets2]  # Use min() to get the smallest number in each set
print("list_of_sets2 minimum from each set =>", min_values6)

print()

# Define a dictionary where each value is a list, and find the max from each list
dict_of_lists = {
    'a': [1, 2, 11],
    'b': [12, 34, 89],
    'c': [12, 34, 23, 67]
}
max_values7 = {k: max(v) for k, v in dict_of_lists.items()}  # Use max() on each value list
print("dict_of_lists maximum from each list =>", max_values7)

print()

# Define another dictionary and find the min from each list
dict_of_lists2 = {
    'a': [1, 2, 11],
    'b': [12, 34, 89],
    'c': [12, 34, 23, 67]
}
min_values8 = {k: min(v) for k, v in dict_of_lists2.items()}  # Use min() on each value list
print("dict_of_lists2 minimum from each list =>", min_values8)



******************OUTPUT ********************

list_of_lists1 maximum from each list => [11, 89, 67]

list_of_lists2 minimum from each list => [1, 12, 12]

list_of_tuples1 maximum from each list => [11, 89, 67]

list_of_tuples2 minimum from each list => [1, 12, 12]

list_of_sets1 maximum from each set => [11, 89, 67]

list_of_sets2 minimum from each set => [1, 12, 12]

dict_of_lists maximum from each list => {'a': 11, 'b': 89, 'c': 67}

dict_of_lists2 minimum from each list => {'a': 1, 'b': 12, 'c': 12}

=== Code Execution Successful ===
