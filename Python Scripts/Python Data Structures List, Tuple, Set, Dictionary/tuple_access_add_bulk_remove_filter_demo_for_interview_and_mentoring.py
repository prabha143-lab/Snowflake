# ✅ Initialize tuple
my_tuple = (1, 2, -1, 3, 8)

# ❌ Invalid operations (commented for clarity)
# print(my_tuple(0)) → TypeError: 'tuple' object is not callable
# my_tuple.append(9) → AttributeError: Tuples are immutable
# my_tuple.add(9) → AttributeError: .add() is for sets, not tuples

# ✅ Accessing elements
print("\nAccess first two elements =>", (my_tuple[0], my_tuple[1]))
print("Slice first two elements =>", my_tuple[0:2])

# ✅ Adding elements (tuples are immutable, so we recreate)
my_tuple += (9,)                        # Add one element
my_tuple += (10, 11, 12)               # Add multiple elements
my_tuple += tuple(range(13, 21))       # Add a range of elements
print("\nExpanded tuple =>", my_tuple)

# ✅ Bulk removal by value
# Define values to remove
values_to_remove = (3, 9, 13, 15, 20, 99)

# Filter only values that actually exist in the tuple
existing_removals = tuple(val for val in values_to_remove if val in my_tuple)

# Create a new tuple excluding those values
my_tuple = tuple(item for item in my_tuple if item not in existing_removals)
print(f"\nRemoved values {existing_removals} =>", my_tuple)

# ✅ Remove by index slice (e.g., index 2 to 5)
# Extract the slice being removed
slice_to_remove = my_tuple[2:7]

# Rebuild the tuple without that slice
my_tuple = my_tuple[:2] + my_tuple[6:]
print(f"\nRemoved slice [2:6] => {slice_to_remove} =>", my_tuple)

# ✅ Remove by condition: remove all odd numbers
# Find all odd numbers
odd_values = tuple(item for item in my_tuple if item % 2 != 0)

# Keep only even numbers
my_tuple = tuple(item for item in my_tuple if item % 2 == 0)
print(f"\nRemoved odd numbers {odd_values} =>", my_tuple)

# ✅ Functional style removal: keep values < 18
# Identify values being filtered out
filtered_out = tuple(item for item in my_tuple if item >= 18)

# Keep only values less than 18 using filter()
my_tuple = tuple(filter(lambda item: item < 18, my_tuple))
print(f"\nFiltered out values >= 18 {filtered_out} =>", my_tuple)


****************************OUTPUT ************************


Access first two elements => (1, 2)
Slice first two elements => (1, 2)

Expanded tuple => (1, 2, -1, 3, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20)

Removed values (3, 9, 13, 15, 20) => (1, 2, -1, 8, 10, 11, 12, 14, 16, 17, 18, 19)

Removed slice [2:6] => (-1, 8, 10, 11, 12) => (1, 2, 12, 14, 16, 17, 18, 19)

Removed odd numbers (1, 17, 19) => (2, 12, 14, 16, 18)

Filtered out values >= 18 (18,) => (2, 12, 14, 16)

=== Code Execution Successful ===
